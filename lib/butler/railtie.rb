require 'butler'
require 'rails'

module Butler
  #
  # Butler::Railtie
  #
  # integrate Butler with Rails
  # and is loaded only when Butler detects
  # a Rails environment
  #
  class Railtie < Rails::Railtie

    use_butler   = Rails.application.config.assets.use_butler || nil
    path         = Rails.application.config.paths['public'].first

    header_rules = Rails.application.config.assets.header_rules || {}
    options      = { header_rules: header_rules }
    # # Initialize Butler
    # initializer "railte.insert_butler_middleware" do |app|
    #   # Config Flags


    #   # Use Butler?
    #   # if use_butler
    #   #   if defined? ActionDispatch::Static
    #   #     if defined? Rack::Cache # will not work
    #   #       app.middleware.delete ActionDispatch::Static
    #   #       app.middleware.insert_before Rack::Cache, Butler::Static, path, options
    #   #     else
    #   #       app.middleware.swap ActionDispatch::Static, Butler::Static, path, options
    #   #     end
    #   #   else
    #   #     app.middleware.use Butler::Static, path, options
    #   #   end
    #   # end
    #   config.middleware.use Butler::Static, path, options
    # end

    config.middleware.delete ActionDispatch::Static
    config.middleware.use Butler::Static, path, options
  end
end