class Merchant::CouponController < ApplicationController
  def index
    binding.pry
    @merchant = Merchant.find(params[:id])
  end
end