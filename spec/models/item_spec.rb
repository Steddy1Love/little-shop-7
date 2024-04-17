require "rails_helper"

RSpec.describe Item, type: :model do
  before :each do
    @merchant1 = Merchant.create!(name: "merchant", status: 0)

    @table = @merchant1.items.create!(name: "table", description: "something", unit_price: 2, status: 0)
    @pen = @merchant1.items.create!(name: "pen", description: "something else", unit_price: 1, status: 1)
  end
  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values({ disabled: 0, enabled: 1 }) }
  end

  describe 'instance methods' do
    describe "#disabled?" do
      it "returns boolean for status" do
        @merchant1 = Merchant.create!(name: "merchant", status: 0)

        @table = @merchant1.items.create!(name: "table", description: "something", unit_price: 2, status: 0)
        @pen = @merchant1.items.create!(name: "pen", description: "something else", unit_price: 1, status: 1)

        expect(@table.disabled?).to be true
        expect(@pen.disabled?).to be false
      end
    end
    describe "#enabled?" do
      it "returns boolean for status" do
        @merchant1 = Merchant.create!(name: "merchant", status: 0)

        @table = @merchant1.items.create!(name: "table", description: "something", unit_price: 2, status: 0)
        @pen = @merchant1.items.create!(name: "pen", description: "something else", unit_price: 1, status: 1)

        expect(@table.enabled?).to be false
        expect(@pen.enabled?).to be true
      end
    end
  end
end
