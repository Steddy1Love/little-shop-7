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

    it 'total_revenue' do
      customer1 = create(:customer, first_name: 'Ron', last_name: 'Burgundy')
      customer2 = create(:customer, first_name: 'Fred', last_name: 'Flintstone')

      item1 = create(:item, name: "Cool Item Name")
      item2 = create(:item)

      invoice1 = create(:invoice, customer: customer1, created_at: 'Mon, 15 Apr 1996 00:00:00.800830000 UTC +00:00', status: 0)
      invoice2 = create(:invoice, customer: customer2, created_at: 'Sun, 01 Jan 2023 00:00:00.800830000 UTC +00:00', status: 1)

      create(:invoice_item, item: item1, invoice: invoice1, quantity: 10, unit_price: 5000, status: 2) 
      create(:invoice_item, item: item2, invoice: invoice1, quantity: 3, unit_price: 55000, status: 1) 
      create(:invoice_item, item: item1, invoice: invoice1, quantity: 8, unit_price: 41000, status: 0) 
      create(:invoice_item, item: item2, invoice: invoice1, quantity: 4, unit_price: 1000, status: 2) 

      create(:invoice_item, item: item1, invoice: invoice2, quantity: 5, unit_price: 2000, status: 2)
      create(:invoice_item, item: item2, invoice: invoice2, quantity: 5, unit_price: 5050, status: 1)

      expect(invoice1.total_revenue).to eq(547000)
      expect(invoice2.total_revenue).to eq(35250)
    end
  end
end
