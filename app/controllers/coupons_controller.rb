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
      coupon_id_for_checking = params[:deactivate_coupon]
      coupon_to_update = Coupon.find(params[:id])
      if coupon_to_update.cannot_deactivate == coupon_id_for_checking.to_i
        flash.now[:notice] = "Coupon is currently in use in an invoice!"
      else
        coupon_to_update.update(status: 0)
      end
      redirect_to merchant_coupon_path(coupon_to_update.merchant_id)
    elsif params.include? :activate_coupon 
      coupon = Coupon.find(params[:activate_coupon])
      coupon.update(status: 1)
      redirect_to merchant_coupon_path(coupon.merchant_id)
    end
  end

  def new
  end

  def create
    @merchant_for_new = Merchant.find(params[:merchant_id])
    @coupon = @merchant_for_new.coupons.new(coupon_params)
      if @coupon.save!
        redirect_to merchant_coupons_path(@merchant_for_new.id), notice: 'Coupon was successfully saved'
      else
        flash.now[:alert] = @coupon.errors.full_messages.join(", ")
        render :new
    end
  end

  private

  def coupon_params
    params.permit(:name, :code, :amount_off, :percent_or_dollar, :merchant_id)
  end
end