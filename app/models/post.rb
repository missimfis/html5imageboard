class Post < ApplicationRecord
  belongs_to :board

  validates :title, presence: true
  validates :svg, presence: true

  scope :newest, -> { order(created_at: :desc) }
end
