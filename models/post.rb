require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'fog'

CarrierWave.configure do |config|
  config.fog_credentials = {
    # Configuration for Amazon S3
    :provider              => 'AWS',
    :aws_access_key_id     => ENV['S3_KEY'],
    :aws_secret_access_key => ENV['S3_SECRET'],
    :region                => 'ap-southeast-2',
    :host   => 's3-ap-southeast-2.amazonaws.com'
  }

  config.storage = :fog
  config.fog_directory    = ENV['S3_BUCKET']
  
  # config.cache_dir = "#{Rails.root}/tmp/uploads"                  # To let CarrierWave work on heroku
end
class MyUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick
  # process resize_to_fit: [800, 800]

  # version :thumb do
  #   process resize_to_fill: [200,200]
  # end
  
  storage :fog

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end

class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :post_type
  has_many :comments
  validates :title, presence: true
  mount_uploader :image_url, MyUploader
end