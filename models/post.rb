require 'carrierwave'
require 'carrierwave/orm/activerecord'

class MyUploader < CarrierWave::Uploader::Base
  storage :file

  # def store_dir 
  #   "/public/"
  # end
end

class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :post_type
  has_many :comments
  validates :title, presence: true
  mount_uploader :image_url, MyUploader
end