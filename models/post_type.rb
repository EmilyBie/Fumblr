class PostType < ActiveRecord::Base
  has_many :posts
  validates :type_name, presence: true 
end