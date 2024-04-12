class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
    @enabled_merchants = Merchant.enabled_merchants
    @disabled_merchants = Merchant.disabled_merchants
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])

    if params[:name].present?
      if merchant.update!(merchant_params)
        flash[:notice] = "#{merchant.name} info updated successfully."
        redirect_to admin_merchant_path(merchant)
      end
    else
      merchant.update!(status: params[:status])
      redirect_to admin_merchants_path
    end
  end

  private
  def merchant_params
    params.permit(:name, :status)
  end
end
