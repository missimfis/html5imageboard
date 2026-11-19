module Ownable
  extend ActiveSupport::Concern

  included do
    validates :owner_token, length: { maximum: 128 }, allow_nil: true
  end

  def owned_by?(token)
    owner_token.present? && token.present? &&
      ActiveSupport::SecurityUtils.secure_compare(owner_token, token)
  end
end
