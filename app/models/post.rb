class Post < ActiveRecord::Base
  self.per_page = 4
  belongs_to :thread
end
