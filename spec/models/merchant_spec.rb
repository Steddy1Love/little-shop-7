require "rails_helper"

RSpec.describe Merchant, type: :model do

  before(:each) do
    @merchant1 = create(:merchant)

    @items_merchant1 = create_list(:item, 5, merchant: @merchant1)

    # @customers = create_list(:customer, 6)
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
    @invoice_customer6 = create(:invoice, customer: @customer6, status: 1)
    @invoice_customer7 = create(:invoice, customer: @customer7, status: 1)

    @invoice_items1 = create(:invoice_item, invoice: @invoice_customer1, item: @items_merchant1.first )
    @invoice_items2 = create(:invoice_item, invoice: @invoice_customer2, item: @items_merchant1.first )
    @invoice_items3 = create(:invoice_item, invoice: @invoice_customer3, item: @items_merchant1.second )
    @invoice_items4 = create(:invoice_item, invoice: @invoice_customer4, item: @items_merchant1.third )
    @invoice_items5 = create(:invoice_item, invoice: @invoice_customer5, item: @items_merchant1.third )
    @invoice_items6 = create(:invoice_item, invoice: @invoice_customer6, item: @items_merchant1.fifth )
    @invoice_items7 = create(:invoice_item, invoice: @invoice_customer7, item: @items_merchant1.fifth )

    @transactions_invoice1 = create_list(:transaction, 6, invoice: @invoice_customer1, result: 1)
    @transactions_invoice2 = create_list(:transaction, 4, invoice: @invoice_customer2, result: 1)
    @transactions_invoice3 = create_list(:transaction, 7, invoice: @invoice_customer3, result: 1)
    @transactions_invoice4 = create_list(:transaction, 9, invoice: @invoice_customer4, result: 1)
    @transactions_invoice5 = create_list(:transaction, 3, invoice: @invoice_customer5, result: 1)
    @transactions_invoice6 = create_list(:transaction, 2, invoice: @invoice_customer6, result: 1)
    @transactions_invoice7 = create_list(:transaction, 3, invoice: @invoice_customer7, result: 0)
  end

  describe "relationships" do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe '#instance methods' do
    it 'should return the top five customers based off of successful transactions for a merchant' do
      expect(@merchant1.top_five_customers).to eq([@customer4, @customer3, @customer1, @customer2, @customer5])
      expect(@merchant1.top_five_customers).to_not include(@customer6)
      expect(@merchant1.top_five_customers).to_not include(@customer7)
    end
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values({ disabled: 0, enabled: 1 }) }
  end
end
