require 'rails_helper'

RSpec.describe 'merchant dashboard show page', type: :feature do
  before(:each) do
        @merchant1 = FactoryBot.create(:merchant)
        @merchant2 = FactoryBot.create(:merchant)

        @item_1 = FactoryBot.create(:item, name: "Organic wood", merchant_id: @merchant1.id)
        @item_2 = FactoryBot.create(:item, name: "Yoga mat", merchant_id: @merchant1.id)
        @item_3 = FactoryBot.create(:item, name: "Headphones", merchant_id: @merchant1.id)
        @item_4 = FactoryBot.create(:item, name: "Kangen water", merchant_id: @merchant1.id)
        @item_5 = FactoryBot.create(:item, name: "Left shoe", merchant_id: @merchant1.id)
        @item_6 = FactoryBot.create(:item, name: "Right shoe", merchant_id: @merchant1.id)
        @item_7 = FactoryBot.create(:item, name: "Coffee mug", merchant_id: @merchant1.id)
        @item_8 = FactoryBot.create(:item, name: "Bed frame", merchant_id: @merchant1.id)
        @item_9 = FactoryBot.create(:item, name: "Tiny house", merchant_id: @merchant1.id)
        @item_10 = FactoryBot.create(:item, name: "Cat litter", merchant_id: @merchant1.id)

        # @customer_list = FactoryBot.create_list(:customer, 8)
        @customer_1 = (first_name: "Dana", last_name: "Howell")
        @customer_2 = (first_name: "Nico", last_name: "Shanstrom")
        @customer_3 = (first_name: "Jared", last_name: "Hobson")
        @customer_4 = (first_name: "Steddy", last_name: "Bell")
        @customer_5 = (first_name: "Jenna", last_name: "Goode")
        @customer_6 = (first_name: "Grant", last_name: "Davis")
        @customer_7 = (first_name: "Abdul", last_name: "Redd")
        @customer_8 = (first_name: "Chris", last_name: "Simmons")

        # invoices_for_customer_1 = create_list(:invoice, 8 customer: @customer_1)

        @invoice_1 = FactoryBot.create(:invoice, customer_id: @customer_1.id, status: 1)
        @invoice_2 = FactoryBot.create(:invoice, customer_id: @customer_2.id, status: 1)
        @invoice_3 = FactoryBot.create(:invoice, customer_id: @customer_3.id, status: 1)
        @invoice_4 = FactoryBot.create(:invoice, customer_id: @customer_4.id, status: 1)
        @invoice_5 = FactoryBot.create(:invoice, customer_id: @customer_5.id, status: 1)
        @invoice_6 = FactoryBot.create(:invoice, customer_id: @customer_6.id, status: 1)
        @invoice_7 = FactoryBot.create(:invoice, customer_id: @customer_7.id, status: 1)
        @invoice_8 = FactoryBot.create(:invoice, customer_id: @customer_8.id, status: 1)

        @invoice_item_1 = FactoryBot.create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id)
        @invoice_item_2 = FactoryBot.create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_1.id)
        @invoice_item_3 = FactoryBot.create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_1.id)
        @invoice_item_4 = FactoryBot.create(:invoice_item, item_id: @item_4.id, invoice_id: @invoice_2.id)
        @invoice_item_5 = FactoryBot.create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_2.id)
        @invoice_item_6 = FactoryBot.create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_3.id)
        @invoice_item_7 = FactoryBot.create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_3.id)

        
        visit dashboard_merchant_path(@merchant1)
        #"/merchants/#{@merchant1.id}/dashboard"
        #
  end

  describe ' USER STORY #1' do
    describe ' as a user when I visit /merchants/:merchant_id/dashboard' do
      
      it 'displays' do
        # Then I see the name of my merchant
        expect(page).to have_content(@merchant1.name)
      end
    end 
  end

  describe 'User Story 2' do
    it 'has links for merchant items index and invoices index' do
      # As a merchant,
      # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
      # Then I see link to my merchant items index (/merchants/:merchant_id/items)
      expect(page).to have_link("Merchant Items")
      # And I see a link to my merchant invoices index (/merchants/:merchant_id/invoices)
      expect(page).to have_link("Merchant Invoices")
    end
  end

  describe 'User Story 3' do
    it 'shows the names of the top 5 customers with the largest number of successful transactions' do
      # As a merchant,
      # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
      # Then I see the names of the top 5 customers
      # who have conducted the largest number of successful transactions with my merchant
      # And next to each customer name I see the number of successful transactions they have
      # conducted with my merchant
      within '.top5' do
        expect(page).to have_content("Customer name: #{@customer1.name} - #{@customer1.successful_transations} successful transactions" )
        expect(page).to have_content()
        expect(page).to have_content()
        expect(page).to have_content()
        expect(page).to have_content()
      end
    end
  end
end