class CouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @coupons = @merchant.coupons
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = @merchant.coupons.new(coupon_params)
    if @coupon.save
      redirect_to merchant_coupons_path(@merchant.id)
    else
      flash.now[:notice] = "Required information missing or code is not unique"
      render :new
    end
  end

  private

  def coupon_params
    params.permit(:name, :code, :percent_off, :dollar_off)
  end
end