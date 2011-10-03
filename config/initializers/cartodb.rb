require 'cartodb-rb-client'

cartodb_settings = YAML.load_file(Rails.root.join('config/cartodb_config.yml'))[Rails.env.to_s] || {} rescue {}
cartodb_settings = cartodb_settings.merge(Hash[ENV].slice(cartodb_settings.keys))
CartoDB::Init.start cartodb_settings
