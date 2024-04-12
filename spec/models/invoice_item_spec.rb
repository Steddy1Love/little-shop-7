require "rails_helper"

RSpec.describe InvoiceItem, type: :model do
  before :each do
    @invoice_item = FactoryBot.create(:invoice_item)
  end
  describe "relationships" do
    it { should belong_to(:item) }
    it { should have_one(:merchant).through(:item) }
    it { should belong_to(:invoice) }
    # .transaction is a built in AR method and cant use as an association
    # it { should have_one(:transaction).through(:invoice) }
    it { should have_one(:customer).through(:invoice) }
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values({ pending: 0, packaged: 1, shipped: 2 }) }
  end

  describe "validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
  end

  describe "class methods" do
    describe ".items_not_shipped" do
      it "returns all invoice_items with pending or packaged status" do
        @merchant1 = create(:merchant)
        # @merchant2 = create(:merchant)

        @table = create(:item, name: "table", merchant: @merchant1)
        @pen = create(:item, name: "pen", merchant: @merchant1)
        @mat = create(:item, name: "yoga mat", merchant: @merchant1)
        @mug = create(:item, name: "mug", merchant: @merchant1)
        @ember = create(:item, name: "ember", merchant: @merchant1)
        @plant = create(:item, name: "plant", merchant: @merchant1)
        # @items_merchant2 = create_list(:item, 5, merchant: @merchant2)

        @customers = create_list(:customer, 6)

        @invoices_customer1 = create(:invoice, customer: @customers.first, status: 1)
        @invoices_customer2 = create(:invoice, customer: @customers.second, status: 1)
        @invoices_customer3 = create(:invoice, customer: @customers.third, status: 1)
        @invoices_customer4 = create(:invoice,  customer: @customers.fourth, status: 1)
        @invoices_customer5 = create(:invoice, customer: @customers.fifth, status: 1)
        @invoices_customer6 = create(:invoice, customer: @customers.last, status: 1)

        @invoice_items1 = create(:invoice_item, invoice: @invoices_customer1, item: @table, status: 0 )
        @invoice_items2 = create(:invoice_item, invoice: @invoices_customer2, item: @pen, status: 0 )
        @invoice_items3 = create(:invoice_item, invoice: @invoices_customer3, item: @mat, status: 1 )
        @invoice_items4 = create(:invoice_item, invoice: @invoices_customer4, item: @mug, status: 1 )
        @invoice_items5 = create(:invoice_item, invoice: @invoices_customer5, item: @ember, status: 2 )#shiped
        @invoice_items6 = create(:invoice_item, invoice: @invoices_customer6, item: @plant, status: 2 )#shipped
        
        @transactions_invoice1 = create_list(:transaction, 5, invoice: @invoices_customer1, result: 1)
        @transactions_invoice2 = create_list(:transaction, 4, invoice: @invoices_customer2, result: 1)
        @transactions_invoice3 = create_list(:transaction, 6, invoice: @invoices_customer3, result: 1)
        @transactions_invoice4 = create_list(:transaction, 7, invoice: @invoices_customer4, result: 1)
        @transactions_invoice5 = create_list(:transaction, 3, invoice: @invoices_customer5, result: 1)
        @transactions_invoice6 = create_list(:transaction, 9, invoice: @invoices_customer6, result: 1)
        
        expect(InvoiceItem.items_not_shipped).to eq([@table.name, @pen.name, @mat.name, @mug.name])
      end
    end
  end
end
