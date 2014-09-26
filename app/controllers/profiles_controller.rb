class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @profile = Profile.new
  end

  def edit
  end

  def create
    @profile = Profile.new(profile_params)
    current_user.profile = @profile
    respond_to do |format|
      if @profile.save && @profile.update_attribute(:newsletter, profile_params[:newsletter].to_i)
        shopify_customer = ShopifyAPI::Customer.find(current_user.shopify_customer_id)
        shopify_customer.accepts_marketing = @profile.newsletter == 0 ? false : true
        shopify_customer.addresses << {address1: profile_params[:street_address], city: profile_params[:city],
                                                            country: 'united states', company: profile_params[:company], zip: profile_params[:zip],
                                                             phone: profile_params[:preferred_phone], province: profile_params[:state]}
        shopify_customer.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render action: 'show', status: :created, location: @profile }
      else
        format.html { render action: 'new' }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @profile.update(profile_params) && @profile.update_attribute(:newsletter, profile_params[:newsletter].to_i)
        shopify_customer = ShopifyAPI::Customer.find(current_user.shopify_customer_id)
        shopify_customer.accepts_marketing = @profile.newsletter == 0 ? false : true
        address = shopify_customer.addresses.first
        address.address1 = profile_params[:street_address]
        address.city = profile_params[:city]
        address.company = profile_params[:company]
        address.zip = profile_params[:zip]
        address.phone = profile_params[:preferred_phone]
        address.province = profile_params[:state]
        shopify_customer.save
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_profile
      begin
        @profile = Profile.find(params[:id])
      rescue
        flash[:alert] = "You need to set your profile up!"
        redirect_to action: :new
      end
    end

    def profile_params
      params.require(:profile).permit(:street_address, :city, :state, :zip, :preferred_phone, :company, :newsletter)
    end
end
