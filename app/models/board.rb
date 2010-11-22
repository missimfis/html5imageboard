class Board < ActiveRecord::Base
  has_many :posts
  validates_uniqueness_of :title
  validates_presence_of :title
end
