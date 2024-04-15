require "rails_helper"

RSpec.describe Invoice, type: :model do
  before :each do
    @invoice = create(:invoice)
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
   
    @items_merchant1 = create_list(:item, 5, merchant: @merchant1)
    @items_merchant2 = create_list(:item, 5, merchant: @merchant2)
   
    @customer1 = create(:customer)
    @customer2 = create(:customer)
    @customer3 = create(:customer)
    @customer4 = create(:customer)
    @customer5 = create(:customer)
    @customer6 = create(:customer)
    @customer7 = create(:customer)

    @invoice_customer1 = create(:invoice, customer: @customer1, status: 1)
    @invoice_customer2 = create(:invoice, customer: @customer2, status: 1)
    @invoice_customer3 = create(:invoice, customer: @customer3, status: 1)
    @invoice_customer4 = create(:invoice, customer: @customer4, status: 1)
    @invoice_customer5 = create(:invoice, customer: @customer5, status: 1)
    @invoice_customer6 = create(:invoice, customer: @customer6, status: 2)
    @invoice_customer7 = create(:invoice, customer: @customer7, status: 2)

    @invoice_items1 = create(:invoice_item, invoice: @invoice_customer1, item: @items_merchant1.first)
    @invoice_items2 = create(:invoice_item, invoice: @invoice_customer2, item: @items_merchant1.first )
    @invoice_items3 = create(:invoice_item, invoice: @invoice_customer3, item: @items_merchant1.second )
    @invoice_items4 = create(:invoice_item, invoice: @invoice_customer4, item: @items_merchant1.third )
    @invoice_items5 = create(:invoice_item, invoice: @invoice_customer5, item: @items_merchant1.third)
    @invoice_items6 = create(:invoice_item, invoice: @invoice_customer6, item: @items_merchant1.fifth )
    @invoice_items7 = create(:invoice_item, invoice: @invoice_customer7, item: @items_merchant1.fifth )
    @invoice_items8 = create(:invoice_item, invoice: @invoice_customer1, item: @items_merchant2.first )
    @invoice_items9 = create(:invoice_item, invoice: @invoice_customer2, item: @items_merchant2.first )
    @invoice_items10 = create(:invoice_item, invoice: @invoice_customer3, item: @items_merchant2.second )
    @invoice_items11 = create(:invoice_item, invoice: @invoice_customer4, item: @items_merchant2.third )
    @invoice_items12 = create(:invoice_item, invoice: @invoice_customer5, item: @items_merchant2.third )
    @invoice_items13 = create(:invoice_item, invoice: @invoice_customer6, item: @items_merchant2.fifth )
    @invoice_items14 = create(:invoice_item, invoice: @invoice_customer7, item: @items_merchant2.fifth)

    @transactions_invoice1 = create_list(:transaction, 5, invoice: @invoice_customer1, result: 1)
    @transactions_invoice2 = create_list(:transaction, 4, invoice: @invoice_customer2, result: 0)
    @transactions_invoice3 = create_list(:transaction, 6, invoice: @invoice_customer3, result: 1)
    @transactions_invoice4 = create_list(:transaction, 7, invoice: @invoice_customer4, result: 1)
    @transactions_invoice5 = create_list(:transaction, 3, invoice: @invoice_customer5, result: 0)
    @transactions_invoice6 = create_list(:transaction, 9, invoice: @invoice_customer6, result: 1)
    @transactions_invoice7 = create_list(:transaction, 10, invoice: @invoice_customer7, result: 0)
    @transactions_invoice8 = create_list(:transaction, 5, invoice: @invoice_customer1, result: 1)
    @transactions_invoice9 = create_list(:transaction, 4, invoice: @invoice_customer2, result: 1)
    @transactions_invoice10 = create_list(:transaction, 6, invoice: @invoice_customer3, result: 1)
    @transactions_invoice11 = create_list(:transaction, 7, invoice: @invoice_customer4, result: 0)
    @transactions_invoice12 = create_list(:transaction, 3, invoice: @invoice_customer5, result: 0)
    @transactions_invoice13 = create_list(:transaction, 9, invoice: @invoice_customer6, result: 0)
    @transactions_invoice14 = create_list(:transaction, 10, invoice: @invoice_customer7, result: 0)
  end

  describe "relationships" do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values({ 'in progress' => 0, 'completed' => 1, 'cancelled' => 2 }) }
  end

  describe "class methods" do
    it ".query for incomplete invoices ordered by oldest to newest" do
      list_test = Invoice.all.incomplete_invoices.limit(3)
      expect(list_test).to match_array([@invoice_customer7, @invoice_customer6, @invoice_customer5])
    end
  end

  describe "instance method" do
    it "#formatted_date" do
      @customer = Customer.create!(first_name: "Blake", last_name: "Sergesketter")
      @invoice = Invoice.create!(status: 1, customer_id: @customer.id, created_at: "Sat, 13 Apr 2024 23:10:10.717784000 UTC +00:00")
      expect(@invoice.formatted_date).to eq("Saturday, April 13, 2024")
      #Saturday, April 13, 2024
    end
  end
end
