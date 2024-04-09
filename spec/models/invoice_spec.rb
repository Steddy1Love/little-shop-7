require "rails_helper"

RSpec.describe Invoice, type: :model do
  before :each do
    @invoice = FactoryBot.create(:invoice)
    binding.pry
  end

  describe "relationships" do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values({ cancelled: 0, in_progress: 1, completed: 2 }) }
  end
end
