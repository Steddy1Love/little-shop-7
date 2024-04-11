require 'rails_helper'

RSpec.describe 'merchant dashboard show page', type: :feature do
  before(:each) do
        @merchant1 = FactoryBot.create(:merchant)
        # @merchant2 = FactoryBot.create(:merchant)

        @items_merchant1 = FactoryBot.create_list(:item, 5, merchant: @merchant1)
        # @items_merchant2 = FactoryBot.create_list(:item, 5, merchant: @merchant2)

        @customers = FactoryBot.create_list(:customer, 10)

        @invoices_customer1 = FactoryBot.create_list(:invoice, 5, customer: @customers.first)
        @invoices_customer2 = FactoryBot.create_list(:invoice, 4, customer: @customers.second)
        @invoices_customer3 = FactoryBot.create_list(:invoice, 6, customer: @customers.third)
        @invoices_customer4 = FactoryBot.create_list(:invoice, 10, customer: @customers.fourth)
        @invoices_customer5 = FactoryBot.create_list(:invoice, 3, customer: @customers.fifth)
        @invoices_customer6 = FactoryBot.create_list(:invoice, 2, customer: @customers.last)


        @invoice_items1 = FactoryBot.create_list(:invoice_item, 3, invoice: @invoices_customer1.first, item: @items_merchant1.first )
        @invoice_items2 = FactoryBot.create_list(:invoice_item, 4, invoice: @invoices_customer2.second, item: @items_merchant1.first )
        @invoice_items3 = FactoryBot.create_list(:invoice_item, 6, invoice: @invoices_customer3.first, item: @items_merchant1.second )
        @invoice_items4 = FactoryBot.create_list(:invoice_item, 5, invoice: @invoices_customer4.second, item: @items_merchant1.third )
        @invoice_items5 = FactoryBot.create_list(:invoice_item, 4, invoice: @invoices_customer5.first, item: @items_merchant1.third )
        @invoice_items6 = FactoryBot.create_list(:invoice_item, 3, invoice: @invoices_customer6.first, item: @items_merchant1.fifth )

        @transactions_invoice1 = FactoryBot.create_list(:transaction, 5, invoice: @invoices_customer1.first, result: 1)
        @transactions_invoice2 = FactoryBot.create_list(:transaction, 4, invoice: @invoices_customer2.first, result: 1)
        @transactions_invoice3 = FactoryBot.create_list(:transaction, 6, invoice: @invoices_customer3.first, result: 1)
        @transactions_invoice4 = FactoryBot.create_list(:transaction, 7, invoice: @invoices_customer4.second, result: 1)
        @transactions_invoice5 = FactoryBot.create_list(:transaction, 3, invoice: @invoices_customer5.third, result: 1)
        @transactions_invoice6 = FactoryBot.create_list(:transaction, 9, invoice: @invoices_customer6.first, result: 1)
        
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
        top_customers.each do |customer|
          expect(page).to have_content("Customer name: #{customer.first_name} #{customer.last_name} - #{customer.successful_transactions_count} successful transactions")
        end
      end
    end
  end
end