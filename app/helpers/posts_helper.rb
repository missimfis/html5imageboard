module PostsHelper
  def post_image_tag(post, **)
    image_tag post_image_path(post, v: post.updated_at.to_i),
              alt: "Drawing for #{post.title}",
              width: 600,
              height: 400,
              loading: "lazy",
              decoding: "async",
              **
  end

  def drawbox_restore_url(post)
    post_image_path(post, v: post.updated_at.to_i) if post.persisted?
  end
end
