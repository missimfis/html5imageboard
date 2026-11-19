class Post < ApplicationRecord
  include Ownable

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
  validates :image_data,
            length: { maximum: PngImage::MAX_DATA_LENGTH },
            if: :image_data_changed?

  scope :newest, -> { order(created_at: :desc, id: :desc) }
end
