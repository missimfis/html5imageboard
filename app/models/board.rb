class Board < ActiveRecord::Base
  self.per_page = 6
  validates_uniqueness_of :title
  validates_presence_of :title

  has_many :posts
end
