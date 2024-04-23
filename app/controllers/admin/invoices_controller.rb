class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @coupon = @invoice.coupon
  end

  def update
    invoice = Invoice.find(params[:id])

    Invoice.update(status: params[:status])

    redirect_to admin_invoice_path(invoice)
  end
end
