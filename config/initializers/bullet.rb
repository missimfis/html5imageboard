if defined?(Bullet)
  Rails.application.config.after_initialize do
    if Rails.env.development?
      Bullet.enable = true
      Bullet.alert = true
      Bullet.bullet_logger = true
      Bullet.console = true
      Bullet.rails_logger = true
      Bullet.add_footer = true
    elsif Rails.env.test?
      Bullet.enable = true
      Bullet.raise = true
    end
  end
end
