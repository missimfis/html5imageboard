class Board < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :title, presence: true, uniqueness: true

  scope :newest, -> { order(created_at: :desc) }
end
