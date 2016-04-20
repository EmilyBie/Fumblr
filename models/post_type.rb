class PostType < ActiveRecord::Base
  has_many :posts
  validates :type_name, presence: true 
  has_many :tags
  has_many :users, through: :tags
end