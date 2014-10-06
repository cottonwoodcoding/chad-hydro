class ReviewController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!, only: [:delete]

  def new
    review = Review.new
    review.product_id = params['product_id']
    review.rating = params['score'].to_f
    review.review_text = params['text']
    review.save!
    flash[:notice] = 'Your review has been submitted'
    render nothing: true
  end

  def show
    @reviews = Review.where(product_id: params['product_id'])
    render partial: '/layouts/review'
  end

  def delete
    if admin?
      id = params['id']
      review = Review.find(id)
      review.destroy
    end
    render nothing: true
  end
end
