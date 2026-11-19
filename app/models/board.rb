class Board < ApplicationRecord
  include Ownable

  TITLE_MAX_LENGTH = 80

  has_many :posts, dependent: :destroy

  normalizes :title, with: ->(title) { title.squish }

  validates :title,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: TITLE_MAX_LENGTH }

  scope :newest, -> { order(created_at: :desc, id: :desc) }
end
