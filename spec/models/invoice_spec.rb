require "rails_helper"

RSpec.describe Invoice, type: :model do
  before :each do
    @invoice = FactoryBot.create(:invoice)
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


  describe "instance method" do
    it "formatted_date" do
      @customer = Customer.create!(first_name: "Blake", last_name: "Sergesketter")
      @invoice = Invoice.create!(status: 1, customer_id: @customer.id, created_at: "Sat, 13 Apr 2024 23:10:10.717784000 UTC +00:00")
      expect(@invoice.formatted_date).to eq("Saturday, April 13, 2024")
      #Saturday, April 13, 2024
    end

    it 'customer_name' do
      customer1 = create(:customer, first_name: 'Ron', last_name: 'Burgundy')
      invoice1 = create(:invoice, customer: customer1)
      customer2 = create(:customer, first_name: 'Fred', last_name: 'Flintstone')
      invoice2 = create(:invoice, customer: customer2)
  
      expect(invoice1.customer_name).to eq('Ron Burgundy')
      expect(invoice2.customer_name).to eq('Fred Flintstone')
    end
  end
end
