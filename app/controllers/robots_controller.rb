class RobotsController < ApplicationController
  def show
    expires_in 1.day, public: true

    render plain: <<~TEXT
      User-agent: *
      Allow: /
      Disallow: /boards/*/edit
      Disallow: /boards/*/posts/*/edit

      Sitemap: #{sitemap_url}
    TEXT
  end
end
