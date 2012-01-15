if APP_CONFIG['S3_KEY'].present? && APP_CONFIG['S3_SECRET'].present?
  AWS::S3::Base.establish_connection!(
    :access_key_id     => APP_CONFIG['S3_KEY'],
    :secret_access_key => APP_CONFIG['S3_SECRET']
  )
end
