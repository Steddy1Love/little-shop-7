require "rails_helper"

RSpec.describe Coupon, type: :model do
  let(:merchant) { create(:merchant) }
  let(:coupon) { create(:coupon, merchant: merchant)}

  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoices) }
  end
  
  describe "enums" do
    it { should define_enum_for(:status).with_values({ 'disabled' => 0, 'enabled' => 1 }) }
    it { should define_enum_for(:percent_or_dollar).with_values({ 'percent' => 0, 'dollar' => 1 }) }
  end

  describe "validations" do
    
    context "check_coupon_limit" do

      it "adds an error if merchant has 5 active coupons" do
        5.times { create(:coupon, merchant: merchant, status: 1) }
        coupon = build(:coupon, merchant: merchant, status: 1)
        coupon.valid?
        expect(coupon.errors[:base]).to include("Merchant cannot have more than 5 active coupons")
      end

      it "does not add an error if merchant has less than 5 active coupons" do
        4.times { create(:coupon, merchant: merchant, status: 1) }
        coupon = build(:coupon, merchant: merchant, status: 1)
        coupon.valid?
        expect(coupon.errors[:base]).to_not include("Merchant cannot have more than 5 enabled coupons")
      end
    end

    context "check_unique_code" do

      it "adds an error if coupon code is not unique" do
        existing_coupon = create(:coupon)
        coupon = build(:coupon, code: existing_coupon.code)
        coupon.valid?
        expect(coupon.errors[:base]).to include("Code is not unique")
      end

      it "does not add an error if coupon code is unique" do
        coupon = build(:coupon)
        coupon.valid?
        expect(coupon.errors[:base]).to_not include("Code is not unique")
      end
    end
  end
end