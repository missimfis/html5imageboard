require "test_helper"

class MetaControllerTest < ActionDispatch::IntegrationTest
  test "robots.txt allows crawling and points to the sitemap" do
    get robots_url
    assert_response :success
    assert_match "User-agent: *", response.body
    assert_match "Allow: /", response.body
    assert_match "Disallow: /boards/*/edit", response.body
    assert_match "Disallow: /moderation", response.body
    assert_match "Sitemap: #{sitemap_url}", response.body
  end

  test "sitemap.xml lists root, boards and posts as absolute urls" do
    get sitemap_url
    assert_response :success
    assert_match "<urlset", response.body
    assert_match "<loc>#{root_url}</loc>", response.body
    assert_match "<loc>#{board_url(boards(:general))}</loc>", response.body
    assert_match "<loc>#{board_post_url(boards(:general), posts(:hello))}</loc>", response.body
  end

  test "pages render SEO meta tags" do
    get boards_url
    assert_response :success
    assert_select "title", "Boards - ImageBoard"
    assert_select "meta[name='description']"
    assert_select "link[rel='canonical'][href=?]", boards_url
    assert_select "meta[property='og:title']"
    assert_select "meta[property='og:site_name'][content='ImageBoard']"

    get board_url(boards(:general))
    assert_select "title", "Board: General Discussion - ImageBoard"

    get board_post_url(boards(:general), posts(:hello))
    assert_select "title", "First post - ImageBoard"
    assert_select "meta[property='og:image'][content=?]", post_image_url(posts(:hello).id)
    assert_select "meta[name='twitter:card'][content='summary_large_image']"
  end

  test "layout exposes accessibility and theme hooks" do
    get boards_url
    assert_response :success
    assert_select "html[lang='en']"
    assert_select "a.skip-link[href='#main']"
    assert_select "main#main"
    assert_select "[aria-expanded='false']#new_board_button"
    assert_select "[aria-controls='new_board_form']#new_board_button"
    assert_select "button[data-action='theme#toggle']"
    assert_select "nav[aria-label='Primary']"
  end

  test "health check responds" do
    get rails_health_check_url
    assert_response :success
  end
end
