class ModerationController < ApplicationController
  rate_limit to: 5, within: 1.minute, only: :create

  def new; end

  def create
    return redirect_to_disabled_moderation unless moderation_configured?

    if valid_password?(params[:password])
      enable_moderation
      redirect_to boards_path, notice: t("moderation.signed_in"), status: :see_other
    else
      redirect_to new_moderation_path,
                  alert: t("moderation.invalid_password"),
                  status: :see_other
    end
  end

  def destroy
    session.delete(:moderator)
    redirect_to boards_path, notice: t("moderation.signed_out"), status: :see_other
  end

  private

  def redirect_to_disabled_moderation
    redirect_to boards_path, alert: t("moderation.disabled"), status: :see_other
  end

  def valid_password?(candidate)
    candidate.present? &&
      ActiveSupport::SecurityUtils.secure_compare(
        candidate.to_s,
        moderation_password.to_s
      )
  end

  def enable_moderation
    owner_token = session[:owner_token]
    reset_session
    session[:owner_token] = owner_token if owner_token.present?
    session[:moderator] = true
  end
end
