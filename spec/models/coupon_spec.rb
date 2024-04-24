require "rails_helper"

RSpec.describe Coupon, type: :model do
  before :each do
    @merchant1 = FactoryBot.create(:merchant) 
    @merchant2 = FactoryBot.create(:merchant)

    @table = FactoryBot.create(:item, name: "table", merchant: @merchant1)
    @pen = FactoryBot.create(:item, name: "pen", merchant: @merchant1)
    @mat = FactoryBot.create(:item, name: "yoga mat", merchant: @merchant1)
    @mug = FactoryBot.create(:item, name: "mug", merchant: @merchant1)
    @ember = FactoryBot.create(:item, name: "ember", merchant: @merchant1)
    @plant = FactoryBot.create(:item, name: "plant", merchant: @merchant1)
    @plant2 = FactoryBot.create(:item, name: "Orchid", merchant: @merchant2)
    @pooltoy = FactoryBot.create(:item, name: "Pool noodle", merchant: @merchant2)
    @bear = FactoryBot.create(:item, name: "Teddy bear", merchant: @merchant2)
    @ball = FactoryBot.create(:item, name: "baseball", merchant: @merchant2)
    @scent = FactoryBot.create(:item, name: "perfume", merchant: @merchant2)
    @tool = FactoryBot.create(:item, name: "screwdriver", merchant: @merchant2)


    @customer1 = FactoryBot.create(:customer)
    @customer2 = FactoryBot.create(:customer)
    @customer3 = FactoryBot.create(:customer)
    @customer4 = FactoryBot.create(:customer)
    @customer5 = FactoryBot.create(:customer)
    @customer6 = FactoryBot.create(:customer)

    @coupon1 = Coupon.create(name: "BOGO50", code: "BOGO50M1", amount_off: 50, percent_or_dollar: 0, status: 1, merchant_id: @merchant1.id)
    @coupon2 = Coupon.create(name: "10OFF", code: "10OFFM1", amount_off: 10, percent_or_dollar: 0, merchant_id: @merchant1.id)
    @coupon3 = Coupon.create(name: "20BUCKS", code: "20OFFM1", amount_off: 2000, percent_or_dollar: 1, status: 1, merchant_id: @merchant1.id)
    @coupon4 = Coupon.create(name: "BOGO50", code: "BOGO50M2", amount_off: 50, percent_or_dollar: 0, merchant_id: @merchant2.id)
    @coupon5 = Coupon.create(name: "10OFF", code: "10OFFM2", amount_off: 10, percent_or_dollar: 0, status: 1, merchant_id: @merchant2.id)
    @coupon6 = Coupon.create(name: "20BUCKS", code: "20OFFM2", amount_off: 2000, percent_or_dollar: 1, status: 1, merchant_id: @merchant2.id)

    @invoice1 = FactoryBot.create(:invoice, customer: @customer1, status: 0, coupon_id: @coupon1.id)
    @invoice2 = FactoryBot.create(:invoice, customer: @customer2, status: 1, coupon_id: @coupon2.id)
    @invoice3 = FactoryBot.create(:invoice, customer: @customer3, status: 1, coupon_id: @coupon3.id)
    @invoice4 = FactoryBot.create(:invoice, customer: @customer4, status: 1, coupon_id: @coupon4.id)
    @invoice5 = FactoryBot.create(:invoice, customer: @customer5, status: 1, coupon_id: @coupon5.id)
    @invoice6 = FactoryBot.create(:invoice, customer: @customer6, status: 1, coupon_id: @coupon6.id)

    @invoice_items1 = FactoryBot.create(:invoice_item, invoice: @invoice1, item: @table, status: 0 ) #pending
    @invoice_items2 = FactoryBot.create(:invoice_item, invoice: @invoice1, item: @plant2, status: 0 ) #pending
    @invoice_items3 = FactoryBot.create(:invoice_item, invoice: @invoice2, item: @pen, status: 0 ) #pending
    @invoice_items4 = FactoryBot.create(:invoice_item, invoice: @invoice3, item: @mat, status: 1 ) #packaged
    @invoice_items5 = FactoryBot.create(:invoice_item, invoice: @invoice4, item: @plant2, status: 1 ) #packaged
    @invoice_items6 = FactoryBot.create(:invoice_item, invoice: @invoice5, item: @ball, status: 2 )#shiped
    @invoice_items7 = FactoryBot.create(:invoice_item, invoice: @invoice6, item: @scent, status: 2 )#shipped

    @transactions_invoice1 = FactoryBot.create_list(:transaction, 5, invoice: @invoice1, result: 1)
    @transactions_invoice2 = FactoryBot.create_list(:transaction, 4, invoice: @invoice2, result: 1)
    @transactions_invoice3 = FactoryBot.create_list(:transaction, 6, invoice: @invoice3, result: 1)
    @transactions_invoice4 = FactoryBot.create_list(:transaction, 7, invoice: @invoice4, result: 1)
    @transactions_invoice5 = FactoryBot.create_list(:transaction, 3, invoice: @invoice1, result: 1)
    @transactions_invoice6 = FactoryBot.create_list(:transaction, 9, invoice: @invoice1, result: 0)
  end

  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end
  
  describe "enums" do
    it { should define_enum_for(:status).with_values({ inactive: 0, active: 1 }) }
    it { should define_enum_for(:percent_or_dollar).with_values({ 'percent' => 0, 'dollar' => 1 }) }
  end

  describe "validations" do
    
    it { should validate_uniqueness_of(:code) }

    context "check_coupon_limit" do

      it "adds an error if merchant has 5 active coupons" do
        3.times { create(:coupon, merchant: @merchant1, status: 1) }
        coupon = build(:coupon, merchant: @merchant1, status: 1)
        coupon.valid?
        expect(coupon.errors[:base]).to include("Merchant cannot have more than 5 active coupons")
      end

      it "does not add an error if merchant has less than 5 active coupons" do
        1.times { create(:coupon, merchant: @merchant2, status: 1) }
        coupon = build(:coupon, merchant: @merchant2, status: 1)
        coupon.valid?
        expect(coupon.errors[:base]).to_not include("Merchant cannot have more than 5 enabled coupons")
      end
    end
  end

  describe "#instance methods" do
    it "#number_purchases" do
    #tested with 17 total attempted transactions but 8 were successful
      expect(@coupon1.number_purchases).to eq(8)
    end

    it "#cannot_deactivate" do
      expect(@coupon1.cannot_deactivate).to eq(@coupon1.id)
      expect(@coupon5.cannot_deactivate).to eq(false)
    end
  end
end