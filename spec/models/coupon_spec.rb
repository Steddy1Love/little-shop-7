require "rails_helper"

RSpec.describe Coupon, type: :model do
  
  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoices) }
  end
  
  describe "enums" do
    it { should define_enum_for(:status).with_values({ 'disabled' => 0, 'enabled' => 1 }) }
  end
end