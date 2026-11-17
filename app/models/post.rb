class Post < ApplicationRecord
  TITLE_MAX_LENGTH = 120
  DESCRIPTION_MAX_LENGTH = 5_000

  belongs_to :board, counter_cache: true, touch: true

  normalizes :title, with: ->(title) { title.squish }
  normalizes :description, with: ->(description) { description.strip }

  validates :title,
            presence: true,
            length: { maximum: TITLE_MAX_LENGTH }
  validates :description, length: { maximum: DESCRIPTION_MAX_LENGTH }
  validates :image_data, presence: true

  scope :newest, -> { order(created_at: :desc, id: :desc) }
end
