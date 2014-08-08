class BlogController < ApplicationController
  respond_to :html

  def index
    posts = {}
    @pending_comments = []
    articles = ShopifyAPI::Article.where(blog_id: 6296807).elements
    articles.each do |a|
      date = a.attributes['created_at'].to_datetime.strftime("%B %Y")
      comments = a.comments.elements
      approved_comments = []
      comments.each do |c|
        c.attributes['status'] == 'published' ? (approved_comments << c.attributes) : (@pending_comments << c.attributes)
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

  def delete_comment
    response = ShopifyAPI::Comment.find(params['id'].to_i).remove
    status = response ? 200 : 500
    render :nothing => true, :status => status
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
      comment['id'] = data['id']
      comments << comment
   end
    render partial: '/layouts/comments', :locals => { comments: comments }
  end

  def approve
    @sorted_comments = {}
    @map = {}
    comments = ShopifyAPI::Comment.where(status: 'unapproved')
    comments.each do |c|
      id = c.attributes['article_id']
      @sorted_comments[id] = [] unless @sorted_comments.has_key? id
      @sorted_comments[id] << c.attributes
    end
    @sorted_comments.keys.each do |k|
      title = ShopifyAPI::Article.find(k).attributes['title']
      @map[k] = title
    end
  end

  def process_comments
    params.each do |comment, status|
      approved_count = 0
      removed_count = 0
      case status
      when 'approve'
        ShopifyAPI::Comment.find(comment.to_i).approve
        approved_count += 1
      when 'delete'
        ShopifyAPI::Comment.find(comment.to_i).remove
        removed_count += 1
      else
        next
      end
    end
    redirect_to blog_path, :notice => "Comments successfully updated"
  end

end
