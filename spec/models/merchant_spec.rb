require "rails_helper"

RSpec.describe Merchant, type: :model do

  before(:each) do
    @merchant1 = create(:merchant)
    # @merchant2 = create(:merchant)

    @table = create(:item, name: "table", merchant: @merchant1)
    @pen = create(:item, name: "pen", merchant: @merchant1)
    @mat = create(:item, name: "yoga mat", merchant: @merchant1)
    @mug = create(:item, name: "mug", merchant: @merchant1)
    @ember = create(:item, name: "ember", merchant: @merchant1)
    @plant = create(:item, name: "plant", merchant: @merchant1)

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

    @invoice_items1 = create(:invoice_item, invoice: @invoices_customer1, item: @table, status: 0, quantity: 1, unit_price: 1 )
    @invoice_items2 = create(:invoice_item, invoice: @invoices_customer2, item: @pen, status: 0, quantity: 1, unit_price: 1 )
    @invoice_items3 = create(:invoice_item, invoice: @invoices_customer3, item: @mat, status: 1, quantity: 1, unit_price: 1 ) #pending
    @invoice_items4 = create(:invoice_item, invoice: @invoices_customer4, item: @mug, status: 1, quantity: 1, unit_price: 1 ) #pending
    @invoice_items5 = create(:invoice_item, invoice: @invoices_customer5, item: @ember, status: 2, quantity: 1, unit_price: 1 )#shiped
    @invoice_items6 = create(:invoice_item, invoice: @invoices_customer6, item: @plant, status: 2, quantity: 1, unit_price: 1 )#shipped
    
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

    describe '::top_5_merchants_by_revenue' do
      it 'returns the top 5 merchants sorted by total revenue and had at least one successful transaction' do
        merchant8 = create(:merchant)
        merchant9 = create(:merchant)
        merchant10 = create(:merchant)
        merchant11 = create(:merchant)
        merchant12 = create(:merchant)
        merchant13 = create(:merchant)
        merchant14 = create(:merchant)
  
        invoice8 = create(:invoice)
        invoice9 = create(:invoice)
        invoice10 = create(:invoice)
        invoice11 = create(:invoice)
        invoice12 = create(:invoice)
        invoice13 = create(:invoice)
        invoice14 = create(:invoice)
  
        item8 = create(:item, merchant: merchant8)
        item9 = create(:item, merchant: merchant9)
        item10 = create(:item, merchant: merchant10)
        item11 = create(:item, merchant: merchant11)
        item12 = create(:item, merchant: merchant12)
        item13 = create(:item, merchant: merchant13)
        item14 = create(:item, merchant: merchant14)
  
        invoice_items_m8 = create_list(:invoice_item, 5, unit_price: 5000, quantity: 5, merchant: merchant8, invoice: invoice8, item: item8) #Total Revenue: 125000
        invoice_items_m9 = create_list(:invoice_item, 5, unit_price: 2000, quantity: 3, merchant: merchant9, invoice: invoice9, item: item9) #Total Revenue: 30000
        invoice_items_m10 = create_list(:invoice_item, 5, unit_price: 4000, quantity: 6, merchant: merchant10, invoice: invoice10, item: item10) #Total Revenue: 120000
        invoice_items_m11 = create_list(:invoice_item, 5, unit_price: 3000, quantity: 3, merchant: merchant11, invoice: invoice11, item: item11) #Total Revenue: 45000
        invoice_items_m12 = create_list(:invoice_item, 5, unit_price: 2500, quantity: 3, merchant: merchant12, invoice: invoice12, item: item12) #Total Revenue: 37500
        invoice_items_m13 = create_list(:invoice_item, 10, unit_price: 10000, quantity: 8, merchant: merchant13, invoice: invoice13, item: item13) #Total Revenue: 800000
        invoice_items_m14 = create_list(:invoice_item, 1, unit_price: 500, quantity: 3, merchant: merchant14, invoice: invoice14, item: item14) #Total Revenue: 1500
  
        create(:transaction, result: 1, invoice: invoice8)
        create(:transaction, result: 1, invoice: invoice9)
        create(:transaction, result: 1, invoice: invoice10)
        create(:transaction, result: 1, invoice: invoice11)
        create(:transaction, result: 1, invoice: invoice12)
        create(:transaction, result: 0, invoice: invoice13)
        create(:transaction, result: 1, invoice: invoice14)
        
        top_5_merchants = Merchant.top_5_merchants_by_revenue

        expect(top_5_merchants).to eq([merchant8, merchant10, merchant11, merchant12, merchant9])
        expect(top_5_merchants.first.total_revenue).to eq(125000)
        expect(top_5_merchants.second.total_revenue).to eq(120000)
        expect(top_5_merchants.third.total_revenue).to eq(45000)
        expect(top_5_merchants.fourth.total_revenue).to eq(37500)
        expect(top_5_merchants.last.total_revenue).to eq(30000)
      end
    end
  end
end
