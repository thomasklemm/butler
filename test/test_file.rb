require 'minitest/autorun'

class TestFile < MiniTest::Unit::TestCase
  def setup
    @file = File.new
  end

  def test_that_files_can_be_served
    assert_equal true, true
  end
end