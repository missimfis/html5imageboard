class Board < ApplicationRecord
  validates :title, uniqueness: true, presence: true

  has_many :posts, dependent: :destroy
end
