class CouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @coupons = @merchant.coupons
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def update
    if params.include? :deactivate_coupon
      coup_id = params[:deactivate_coupon]
      coupon = Coupon.find(params[:id])
      if coupon.cannot_deactivate.include?(coup_id)
        flash.now[:notice] = "Coupon is currently in use in an invoice!"
      else
        coupon.update(status: 0)
      end
      redirect_to merchant_coupon_path(coupon.merchant_id)
    elsif params.include? :activate_coupon 
      coup_id = params[:activate_coupon]
      coupon.update(status: 1)
      redirect_to merchant_coupon_path(coupon.merchant_id)
    end
  end

  def new
  end

  def create
    @coupon = @merchant.coupons.new(coupon_params)
      if @coupon.save
        redirect_to merchant_coupons_path(@merchant.id), notice: 'Coupon was successfully saved'
      else
        flash.now[:alert] = @coupon.errors.full_messages.join(", ")
        render :new
    end
  end

  private

  def coupon_params
    params.permit(:name, :code, :amount_off, :percent_or_dollar)
  end
end