module ApplicationHelper
  APP_NAME = "ImageBoard".freeze

  DEFAULT_DESCRIPTION = "ImageBoard is a simple community board where you can " \
                        "draw images with the HTML5 canvas and share them with others.".freeze

  def page_title
    title = content_for(:title).presence
    title ? "#{title} - #{APP_NAME}" : APP_NAME
  end

  def page_description
    content_for(:description).presence || DEFAULT_DESCRIPTION
  end

  def canonical_url
    content_for(:canonical).presence || request.original_url.sub(/\?.*\z/, "")
  end

  def og_image_url
    content_for(:og_image).presence
  end

  def nav_link_to(name, path, active_class: nil, **options)
    active = current_page?(path)
    aria = options.delete(:aria) || {}
    aria[:current] = "page" if active
    options[:class] = [options[:class], active_class].compact.join(" ") if active && active_class

    link_to name, path, aria: aria, **options
  end

  def relative_time(timestamp, prefix: nil)
    return if timestamp.blank?

    time_tag timestamp,
             safe_join([prefix, time_ago_in_words(timestamp), " ago"].compact),
             datetime: timestamp.iso8601,
             title: l(timestamp, format: :long)
  end
end
