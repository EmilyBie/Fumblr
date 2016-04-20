class User < ActiveRecord::Base
  has_secure_password
  has_many :posts
  has_many :tags
  has_many :post_types, through: :tags
end