class MerchantItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end
  def show
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.find(params[:id])
    @merchant_items = @merchant.items
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.find(params[:id])

    if params[:name].present?
      if @item.update!(item_params)
        flash[:notice] = "#{@item.name} info updated successfully."
        redirect_to merchant_item_path(@merchant, @item)
      end
    else
      @item.update!(item_params)
      redirect_to edit_merchant_item_path(@merchant, @item)
    end
  end

  private
    def item_params
      params.permit(:name, :description, :unit_price, :status)
    end
  end