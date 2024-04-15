require "rails_helper"

RSpec.describe Merchant, type: :model do

  before(:each) do
    # @merchant1 = create(:merchant)

    # @items_merchant1 = create_list(:item, 5, merchant: @merchant1)

    # # @customers = create_list(:customer, 6)
    # @customer1 = create(:customer)
    # @customer2 = create(:customer)
    # @customer3 = create(:customer)
    # @customer4 = create(:customer)
    # @customer5 = create(:customer)
    # @customer6 = create(:customer)
    # @customer7 = create(:customer)

    # @invoice_customer1 = create(:invoice, customer: @customer1, status: 1)
    # @invoice_customer2 = create(:invoice, customer: @customer2, status: 1)
    # @invoice_customer3 = create(:invoice, customer: @customer3, status: 1)
    # @invoice_customer4 = create(:invoice, customer: @customer4, status: 1)
    # @invoice_customer5 = create(:invoice, customer: @customer5, status: 1)
    # @invoice_customer6 = create(:invoice, customer: @customer6, status: 1)
    # @invoice_customer7 = create(:invoice, customer: @customer7, status: 1)

    # @invoice_items1 = create(:invoice_item, invoice: @invoice_customer1, item: @items_merchant1.first )
    # @invoice_items2 = create(:invoice_item, invoice: @invoice_customer2, item: @items_merchant1.first )
    # @invoice_items3 = create(:invoice_item, invoice: @invoice_customer3, item: @items_merchant1.second )
    # @invoice_items4 = create(:invoice_item, invoice: @invoice_customer4, item: @items_merchant1.third )
    # @invoice_items5 = create(:invoice_item, invoice: @invoice_customer5, item: @items_merchant1.third )
    # @invoice_items6 = create(:invoice_item, invoice: @invoice_customer6, item: @items_merchant1.fifth )
    # @invoice_items7 = create(:invoice_item, invoice: @invoice_customer7, item: @items_merchant1.fifth )

    # @transactions_invoice1 = create_list(:transaction, 6, invoice: @invoice_customer1, result: 1)
    # @transactions_invoice2 = create_list(:transaction, 4, invoice: @invoice_customer2, result: 1)
    # @transactions_invoice3 = create_list(:transaction, 7, invoice: @invoice_customer3, result: 1)
    # @transactions_invoice4 = create_list(:transaction, 9, invoice: @invoice_customer4, result: 1)
    # @transactions_invoice5 = create_list(:transaction, 3, invoice: @invoice_customer5, result: 1)
    # @transactions_invoice6 = create_list(:transaction, 2, invoice: @invoice_customer6, result: 1)
    # @transactions_invoice7 = create_list(:transaction, 3, invoice: @invoice_customer7, result: 0)
    @merchant1 = create(:merchant)
    # @merchant2 = create(:merchant)

    @table = create(:item, name: "table", merchant: @merchant1)
    @pen = create(:item, name: "pen", merchant: @merchant1)
    @mat = create(:item, name: "yoga mat", merchant: @merchant1)
    @mug = create(:item, name: "mug", merchant: @merchant1)
    @ember = create(:item, name: "ember", merchant: @merchant1)
    @plant = create(:item, name: "plant", merchant: @merchant1)
    # @items_merchant2 = create_list(:item, 5, merchant: @merchant2)

    @customer1 = create(:customer)
    @customer2 = create(:customer)
    @customer3 = create(:customer)
    @customer4 = create(:customer)
    @customer5 = create(:customer)
    @customer6 = create(:customer)
    @customer7 = create(:customer)

    @invoices_customer1 = create(:invoice, customer: @customer1, status: 1)
    @invoices_customer2 = create(:invoice, customer: @customer2, status: 1)
    @invoices_customer3 = create(:invoice, customer: @customer3, status: 1)
    @invoices_customer4 = create(:invoice, customer: @customer4, status: 1)
    @invoices_customer5 = create(:invoice, customer: @customer5, status: 1)
    @invoices_customer6 = create(:invoice, customer: @customer6, status: 1)

    @invoice_items1 = create(:invoice_item, invoice: @invoices_customer1, item: @table, status: 0 )
    @invoice_items2 = create(:invoice_item, invoice: @invoices_customer2, item: @pen, status: 0 )
    @invoice_items3 = create(:invoice_item, invoice: @invoices_customer3, item: @mat, status: 1 ) #pending
    @invoice_items4 = create(:invoice_item, invoice: @invoices_customer4, item: @mug, status: 1 ) #pending
    @invoice_items5 = create(:invoice_item, invoice: @invoices_customer5, item: @ember, status: 2 )#shiped
    @invoice_items6 = create(:invoice_item, invoice: @invoices_customer6, item: @plant, status: 2 )#shipped
    
    @transactions_invoice1 = create_list(:transaction, 5, invoice: @invoices_customer1, result: 1)
    @transactions_invoice2 = create_list(:transaction, 4, invoice: @invoices_customer2, result: 1)
    @transactions_invoice3 = create_list(:transaction, 6, invoice: @invoices_customer3, result: 1)
    @transactions_invoice4 = create_list(:transaction, 7, invoice: @invoices_customer4, result: 1)
    @transactions_invoice5 = create_list(:transaction, 3, invoice: @invoices_customer5, result: 1)
    @transactions_invoice6 = create_list(:transaction, 9, invoice: @invoices_customer6, result: 1)
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
      expect(@merchant1.top_five_customers).to eq([@customer6, @customer4, @customer3, @customer1, @customer2])
      expect(@merchant1.top_five_customers).to_not include(@customer5)
    end

    describe "#items_not_shipped" do
      it "returns all invoice_items with pending or packaged status" do
        expect(@merchant1.packaged_items).to eq([@mat, @mug])

        expect(@merchant1.packaged_items).to_not include(@ember, @plant, @table, @pen)
      end
    end
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values({ disabled: 0, enabled: 1 }) }
  end

  describe '::class methods' do
    before(:each) do
      @enabled_merchant_list = create_list(:merchant, 5, status: 1)
      @disabled_merchant_list = create_list(:merchant, 5, status: 0)
    end

    describe '::enabled' do
      it 'returns only merchants with an enabled status' do
        full_enabled_merchant_list = Merchant.enabled

        @enabled_merchant_list.each do |enabled_merchant|
          expect(full_enabled_merchant_list).to include(enabled_merchant)
        end

        @disabled_merchant_list.each do |disabled_merchant|
          expect(full_enabled_merchant_list).to_not include(disabled_merchant)
        end
      end
    end

    describe '::disabled' do
      it 'returns only merchants with an disabled status' do
        full_disabled_merchant_list = Merchant.disabled

        @disabled_merchant_list.each do |disabled_merchant|
          expect(full_disabled_merchant_list).to include(disabled_merchant)
        end

        @enabled_merchant_list.each do |enabled_merchant|
          expect(full_disabled_merchant_list).to_not include(enabled_merchant)
        end
      end
    end
  end
end
