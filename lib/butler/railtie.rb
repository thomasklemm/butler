module Butler
  class Railtie < ::Rails::Railtie
    puts 'Processing Railtie...'
    # config.butler = ActiveSupport::OrderedOptions.new # enable namespaced configuration in Rails environments

    # # Config
    # use_butler   = Rails.application.config.assets.use_butler || nil
    # path         = Rails.application.config.paths['public'].first

    # header_rules = Rails.application.config.assets.header_rules || {}
    # options      = { header_rules: header_rules }

    initializer "butler.configure_rails_initialization" do |app|
      app.middleware.swap 'ActionDispatch::Static', 'Butler::Static'
      raise app.inspect
      # if use_butler
      #   if defined? ActionDispatch::Static
      #     if defined? Rack::Cache # will not work
      #       app.config.middleware.delete ActionDispatch::Static
      #       app.config.middleware.insert_before Rack::Cache, Butler::Static, path, options
      #     else
      #       app.config.middleware.swap ActionDispatch::Static, Butler::Static, path, options
      #     end
      #   else
      #     app.config.middleware.use Butler::Static, path, options
      #   end
      # end
    end
  end
end