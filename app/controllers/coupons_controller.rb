class CouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @coupons = @merchant.coupons
  end

  def show
    binding.pry
    @coupon = Coupon.find(params[:id])
  end
end