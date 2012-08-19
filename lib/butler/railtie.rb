module Butler
  class Railtie < ::Rails::Railtie
    # # Config
    # Rails.application.config.butler = ActiveSupport::OrderedOptions.new # enable namespaced configuration in Rails environments
    # enable_butler = Rails.application.config.butler.enable_butler || nil
    # path          = Rails.application.config.paths['public'].first

    # header_rules  = Rails.application.config.butler.header_rules || {}
    # options       = { header_rules: header_rules }

    # # Initializer
    # initializer "butler.add_middleware" do |app|
    #   #
    #   # Insert Butler Middleware
    #   # while trying to reach a certain middleware order
    #   #
    #   if enable_butler
    #     if defined? ActionDispatch::Static
    #       if defined? Rack::Cache
    #         app.middleware.delete ActionDispatch::Static
    #         app.middleware.insert_before Rack::Cache, Butler::Static, path, options
    #       else
    #         app.middleware.swap ActionDispatch::Static, Butler::Static, path, options
    #       end
    #     else
    #       app.middleware.use Butler::Static, path, options
    #     end
    #   end
    # end

  end
end