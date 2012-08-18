require 'servely/version'
require 'servely/server'
require 'servely/file_handler'
require 'servely/file'

module Servely
  #
  #   Servely::Server serves static files if it can find them precompiled
  #   and will otherwise send the request onwards in the Rails stack.
  #
  #   Servely::Server allows to set custom headers based on rules.
  #
  #   # Symbol Shortcuts
  #   :global  => { field => content }  # Symbol :global (will match all files)
  #   :fonts   => { field => content }  # Symbol :fonts (will match files with common webfonts extensions)
  #
  #   # Extensions
  #   # provided as an array
  #   ['css', 'js'] => { field => content }  # Array (will match extensions)
  #   %w(css js)    => { field => content }  # Array (will match extensions)
  #
  #   # Folder
  #   # provided as a string
  #   # Note: Take into account that the root folder is '/public'
  #   #       and calculate your routes from there
  #   '/folder' => { field => content }
  #   '/assets/application.js' => { field => content }
  #
  #   # Regexp
  #   # For example all files with extensions css or js
  #   # This approach is very flexible
  #   /\.(css|js)\z/ => { field => content }  # Regexp (flexible)
  #
end
