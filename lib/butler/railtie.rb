module Butler
  class Butler < Rails::Railtie
    initializer 'require Butler' do
      require 'butler'
    end

    initializer 'butler_railtie.configure_rails_initialization' do |app|
      if defined? Rack::Cache
        app.middleware.delete ActionDispatch::Static
        app.middleware.insert_before Rack::Cache, Butler::Static
      else
        app.middleware.swap ActionDispatch::Static, Butler::Static
      end
    end

    config.butler.butler_test = '123'
    config.assets.butler_test = '123'
  end
end