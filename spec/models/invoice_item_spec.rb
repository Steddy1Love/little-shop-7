require "rails_helper"

RSpec.describe InvoiceItem, type: :model do
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
end
