APP_CONFIG = (YAML.load_file(Rails.root.join('config/app_config.yml')) || {} rescue {}).merge(Hash[ENV].slice(*%w(S3_KEY S3_SECRET)))
