$: << File.expand_path('../extensions', __FILE__)
require 'include_code'

activate :include_code
###
# Syntax
###
activate :syntax#, :line_numbers => true
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true, :no_intra_emphasis => true, :autolink => true

@domain = 'wongyouth.github.io'.freeze

###
# Blog settings
###

Time.zone = "Beijing"

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = "blog"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  # blog.sources = "{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  blog.layout = "post"
  blog.summary_separator = /<!-- *more *-->/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  # blog.per_page = 10
  blog.page_link = "page/{num}"

  blog.custom_collections = {
    topic: {
      link: "/topics/:topic.html",
      template: "/topic.html"
    }
  }
end

page "/feed.xml", layout: false

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change

activate :directory_indexes

configure :development do
  set :debug_assets, true
  activate :livereload
end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

sprockets.append_path "#{root}/bower_components"

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

helpers do
  def page_title
    title = yield_content(:title) || current_page.data.title || current_article.try(:title) || data.site.slogon
    "#{title} - #{data.site.name}"
  end

  def page_keywords
    current_page.data.keywords || current_article.try(:keywords) || data.site.keywords
  end

  def page_description
    current_article.try(:description) || current_page.data.description || data.site.description
  end

  def article_url(article)
    if environment == :build
      "http://#{@domain}#{article.url}"
    else
      article.url
    end
  end
end


## Assets
#ready do
  #sprockets.import_asset 'bootstrap-sass'
#end

set :frontmatter_extensions, %w(.html .slim)

case ENV['TARGET'].to_s.downcase
when 'gitcafe'
  activate :deploy do |deploy|
    deploy.build_before = true
    deploy.method = :git
    # Optional Settings
    deploy.remote   = "gitcafe" # remote name or git url, default: origin
    deploy.branch   = "gitcafe-pages" # default: gh-pages
    # deploy.strategy = :force_push      # commit strategy: can be :force_push or :submodule, default: :force_push
  end
else # 'github'
  activate :deploy do |deploy|
    deploy.build_before = false
    deploy.method = :git
    # Optional Settings
    # deploy.remote   = "custom-remote" # remote name or git url, default: origin
    # deploy.branch   = "custom-branch" # default: gh-pages
    deploy.branch   = "master" # default: gh-pages
    deploy.strategy = :force_push      # commit strategy: can be :force_push or :submodule, default: :force_push
  end
end

# site map
set :url_root, data.site.url
activate :search_engine_sitemap
