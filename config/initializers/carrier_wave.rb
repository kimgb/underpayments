CarrierWave.configure do |config|
  config.fog_directory    = ENV['AWS_BUCKET']
  config.fog_attributes   = { 'Cache-Control' => "max-age=#{365.days.to_i}" }
  config.fog_credentials  = {
    provider:              'AWS',
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region:                ENV['AWS_REGION']
  }
  config.storage          = :fog
  config.fog_public       = false

  # For testing, upload files to local `tmp` folder.
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  # else
  #   config.storage = :fog
  end
end
