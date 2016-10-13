class CampaignLogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog
  process :set_content_type

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # Not sure about SVG - does it work with Rails' image_tag helper?
  def extension_white_list
    %w(jpg jpeg tif tiff gif png svg)
  end
  
  protected
  def image?(new_file)
    new_file.content_type.start_with? 'image'
  end
end
