class ApplicationController < ActionController::Base
  BOARDS_PER_PAGE = 10
  POSTS_PER_PAGE = 6

  include Pagy::Method

  allow_browser versions: :modern

  protect_from_forgery with: :exception

  helper_method :moderator?, :moderation_configured?, :owned_by_current_session?

  private

  def current_owner_token
    session[:owner_token] ||= SecureRandom.hex(32)
  end

  def owned_by_current_session?(record)
    record.owned_by?(session[:owner_token])
  end

  def moderator?
    session[:moderator] == true
  end

  def moderation_configured?
    moderation_password.present?
  end

  def moderation_password
    ENV["MODERATOR_PASSWORD"].presence ||
      Rails.application.credentials.moderator_password.presence
  end

  # Creating boards and posts is intentionally public on this anonymous image
  # board. Editing and deleting require the creating session or a moderator.
  def authorize_owner!(record, fallback_location:)
    return if moderator? || owned_by_current_session?(record)

    redirect_to fallback_location,
                alert: t("authorization.denied"),
                status: :see_other
  end
end
