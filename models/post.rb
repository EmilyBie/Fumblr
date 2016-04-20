# require './image_uploader'
class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :post_type
  has_many :comments
  validates :title, presence: true
  # mount_uploader :image_url, ImageUploader
end