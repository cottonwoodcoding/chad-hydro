class BlogController < ApplicationController
  respond_to :html

  def index
    posts = {}
    articles = ShopifyAPI::Article.where(blog_id: 6296807).elements
    articles.each do |a|
      date = a.attributes['created_at'].to_datetime.strftime("%B %Y")
      comments = a.comments.elements
      approved_comments = []
      comments.each do |c|
        approved_comments << c.attributes if c.attributes['status'] == 'published'
      end
      a.attributes['comments'] = approved_comments
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

  def new_comment
    comment = {}
    comment['article_id'] = params['article_id']
    comment['author'] = params.has_key?('name') ? params['name'] : 'anonymous'
    comment['body'] = params['comment']
    comment['email'] = params['email']
    response = ShopifyAPI::Comment.create(comment)
    if response.errors.messages.any?
        redirect_to blog_path, :error => "Error with comment: #{response.errors.messages.values}"
    else
      if user_signed_in?
        response.approve
        redirect_to blog_path
      else
        redirect_to blog_path, :notice => 'Your comment has been submitted for approval'
      end
    end
  end

  def update_comments
    comments = []
    article_comments = ShopifyAPI::Comment.where(article_id: params['article_id'], status: 'published').elements
    article_comments.each_with_index do |c, i|
      data = c.attributes
      comment = {}
      comment['author'] = data['author']
      comment['created_at'] = data['created_at']
      comment['body'] = data['body']
      comments << comment
   end
    render partial: '/layouts/comments', :locals => { comments: comments }
  end

end
