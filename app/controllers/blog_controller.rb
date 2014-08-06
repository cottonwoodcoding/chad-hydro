class BlogController < ApplicationController
  respond_to :html

  def index
    posts = {}
    articles = ShopifyAPI::Article.where(blog_id: 6296807).elements
    articles.each do |a|
      date = a.attributes['created_at'].to_datetime.strftime("%B %Y")
      posts[date] = [] unless posts.has_key? date
      posts[date] << a.attributes
    end
    posts['July 2014'] = [{"created_at" => "2014-07-05"}]
    @articles = posts.each do |k, v|
      v.sort { |x,y| x['created_at'].to_datetime <=> y['created_at'].to_datetime }
    end
    @articles.each { |k,v| v.reverse!}
  end

  def new
  end

  def create
    ShopifyAPI::Article.create(blog_id: 6296807, title: params['title'],
                                  body_html: params['post_body'], author: current_user.name)
    redirect_to blog_path
  end

end
