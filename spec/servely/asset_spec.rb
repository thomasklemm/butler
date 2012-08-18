require 'minitest_helper'
require 'servely/asset'
require 'rack/mock'

describe Servely::Asset do
  DOCROOT = File.expand_path(File.dirname(__FILE__))

  def file(*args)
    Servely::Asset.new(*args)
  end

  before do
    @file = Rack::MockRequest.new(file(DOCROOT))
  end

  describe 'when serving files' do
    #
    # Serve Files
    #
    it 'should serve available files' do
      res = @file.get('files/index.html')

      res.status.must_equal 200
      res.body.must_equal '<html>Index</html>'
    end

    it 'should return status 404 if file cannot be found' do
      res = @file.get('files/unknown.html')

      res.status.must_equal 404
    end

    #
    # Request Methods
    #
    it 'should only support GET and HEAD requests' do
      file = 'files/index.html'

      allowed = %w(get head)
      allowed.each do |method|
        res = @file.send(method, file)
        res.status.must_equal 200
      end

      forbidden = %w(post put delete) # patch is breaking
      forbidden.each do |method|
        res = @file.send(method, file)
        res.status.must_equal 405
      end
    end

    #
    #  Headers
    #
    it 'should set header Last-Modified' do
      file = 'files/index.html'
      path = File.join(DOCROOT, file)
      res = @file.get(file)

      res.status.must_equal 200
      res['Last-Modified'].must_equal File.mtime(path).httpdate
    end
    it "should set Content-Length correctly for HEAD requests" do
      res = @file.head('files/index.html')

      res.status.must_equal 200
      res['Content-Length'].must_equal '18'
    end

    it 'should set provided headers' do
      file = Servely::Asset.new(DOCROOT,
        headers: {'Cache-Control' => 'public, max-age=42'})
      req = Rack::MockRequest.new(file)

      res = req.get('files/index.html')

      res.status.must_equal 200
      res['Cache-Control'].must_equal 'public, max-age=42'
    end

    #
    # Modified / unmodified Files (304 / 200)
    #
    it 'should return status 304 if file is not modified since last serve' do
      file = 'files/index.html'
      path = File.join(DOCROOT, file)
      time = File.mtime(path).httpdate
      res = @file.get(file, 'HTTP_IF_MODIFIED_SINCE' => time)

      res.status.must_equal 304
      res.body.must_be_empty
    end

    it 'should serve the file if it is modified since last serve' do
      file = 'files/index.html'
      path = File.join(DOCROOT, file)
      time = (File.mtime(path) - 60).httpdate
      res = @file.get(file, 'HTTP_IF_MODIFIED_SINCE' => time)

      res.status.must_equal 200
      res.body.must_equal '<html>Index</html>'
    end

    #
    # URL-encoded filenames
    #
    it 'should serve files with URL encoded filenames' do
      res = @file.get('files/%69%6E%64%65%78%2Ehtml')

      res.status.must_equal 200
      res.body.must_equal '<html>Index</html>'
    end

    it 'should allow safe directory traversal' do
      res = @file.get('files/../asset_spec.rb')
      res.status.must_equal 200

      res = @file.get('files/../files/index.html')
      res.status.must_equal 200

      res = @file.get('.')
      res.status.must_equal 404

      res = @file.get('files/..')
      res.status.must_equal 404
    end

    #
    # Directory Traversal
    #
    it 'should not allow unsafe directory traversal' do
      res = @file.get('../minitest_helper.rb')
      res.status.must_equal 404

      res = @file.get('/../minitest_helper.rb')
      res.status.must_equal 404

      res = @file.get('../servely/files/index.html')
      res.status.must_equal 404

      # Ensure file existance
      res = @file.get('files/index.html')
      res.status.must_equal 200
    end

    it 'should allow safe directory traversal with encoded periods' do
      res = @file.get('files/%2E%2E/asset_spec.rb')
      res.status.must_equal 200

      res = @file.get('files/%2E%2E/files/index.html')
      res.status.must_equal 200

      res = @file.get('%2E')
      res.status.must_equal 404

      res = @file.get('files/%2E')
      res.status.must_equal 404
    end

    it 'should not allow unsafe directory traversal with encoded periods' do
      res = @file.get('%2E%2E/minitest_helper.rb')
      res.status.must_equal 404

      res = @file.get('/%2E%2E/minitest_helper.rb')
      res.status.must_equal 404
    end

    it 'should allow files with .. in their name' do
      res = @file.get('files/..test')
      res.status.must_equal 404

      res = @file.get('files/test..')
      res.status.must_equal 404

      res = @file.get('files../test..')
      res.status.must_equal 404
    end

    it 'should detect SystemCallErrors' do
      res = @file.get('/cgi')
      res.status.must_equal 404

      res = @file.get('cgi')
      res.status.must_equal 404

      res = @file.get('/files')
      res.status.must_equal 404

      res = @file.get('files')
      res.status.must_equal 404
    end

    it 'should return bodies that respond to #to_path' do
      file = 'files/index.html'
      path = File.join(DOCROOT, file)
      env = Rack::MockRequest.env_for(file)
      status, _, body = Servely::Asset.new(DOCROOT).call(env)

      status.must_equal 200
      body.must_respond_to :to_path
      body.to_path.must_equal path
    end

    #
    # Byte Ranges
    #
    it 'should return correct byte range in body' do
      res = @file.get('files/index.html', 'HTTP_RANGE' => 'bytes=2-12')

      res.status.must_equal 206
      res.body.must_equal 'tml>Index</'

      res['Content-Length'].must_equal '11'
      # before: res['Content-Range'].must_equal 'bytes=2-12'
      res['Content-Range'].must_equal 'bytes 2-12/18'
    end

    it 'should return error for unsatisfiable byte range' do
      res = @file.get('files/index.html', 'HTTP_RANGE' => 'bytes=1234-5678')

      res.status.must_equal 416
      res['Content-Range'].must_equal 'bytes */18'
    end

    # Skipped: should allow files with .. in their names
  end

end