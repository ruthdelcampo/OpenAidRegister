cartodb_settings = YAML.load_file(Rails.root.join('config/cartodb_config.yml'))[Rails.env.to_s]
cartodb_settings = cartodb_settings.merge(Hash[ENV].slice(hash.keys))
CartoDB::Init.start cartodb_settings
