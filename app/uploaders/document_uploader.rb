# encoding: utf-8

class DocumentUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [75, 75]
  end
  version :standard do
    process :resize_to_fit => [480, 480]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg tif tiff gif png pdf txt doc docx rtf xls xlsx eml msg)
  end

  # TODO - a bit more work than it seems.
  # def thumbnail_pdf
  #   manipulate! do |img|
  #     # first_page = Magick::ImageList.new("#{current_path}[0]").first
  #     # thumb = first_page.resize_to_fit!(75, 75)
  #     # thumb
  #     # img.format("png", 1)
  #     # img.resize("75x75")
  #     # img = yield(img) if block_given?
  #     # img
  #   end
  # end
  
  def set_content_type(*args)
    self.file.instance_variable_set(:@content_type, "image/png")
  end
  
  def image?
    %w(jpg jpeg tif tiff gif png).include? file.extension
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
