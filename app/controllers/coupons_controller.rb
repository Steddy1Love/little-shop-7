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
        redirect_to merchant_coupons_path(@merchant.id), notice: 'Coupon was successfully saved'
      else
        flash.now[:alert] = @coupon.erros.full_messages.join(", ")
        render :new
    end
  end

  private

  def coupon_params
    params.permit(:name, :code, :amount_off, :percent_or_dollar)
  end
end