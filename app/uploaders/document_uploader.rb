# encoding: utf-8

class DocumentUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog
  
  process :set_content_type

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Create different versions of your uploaded files:
  version :thumb, if: :image? do
    process :resize_to_fit => [75, 75]
  end
  version :standard, if: :image? do
    process :resize_to_fit => [480, 480]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg tif tiff gif png pdf txt doc docx rtf xls xlsx eml msg)
  end
  
  def is_image?
    %w(jpg jpeg tif tiff gif png).include? file.extension
  end
  
  protected
  def image?(new_file)
    new_file.content_type.start_with? 'image'
  end
end
