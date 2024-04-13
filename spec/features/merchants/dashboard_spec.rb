require 'rails_helper'

RSpec.describe 'merchant dashboard show page', type: :feature do
  before(:each) do
    @merchant1 = create(:merchant)
    # @merchant2 = create(:merchant)

    @table = create(:item, name: "table", merchant: @merchant1)
    @pen = create(:item, name: "pen", merchant: @merchant1)
    @mat = create(:item, name: "yoga mat", merchant: @merchant1)
    @mug = create(:item, name: "mug", merchant: @merchant1)
    @ember = create(:item, name: "ember", merchant: @merchant1)
    @plant = create(:item, name: "plant", merchant: @merchant1)
    # @items_merchant2 = create_list(:item, 5, merchant: @merchant2)

    @customer1 = create(:customer)
    @customer2 = create(:customer)
    @customer3 = create(:customer)
    @customer4 = create(:customer)
    @customer5 = create(:customer)
    @customer6 = create(:customer)

    @invoices_customer1 = create(:invoice, customer: @customer1, status: 1)
    @invoices_customer2 = create(:invoice, customer: @customer2, status: 1)
    @invoices_customer3 = create(:invoice, customer: @customer3, status: 1)
    @invoices_customer4 = create(:invoice, customer: @customer4, status: 1)
    @invoices_customer5 = create(:invoice, customer: @customer5, status: 1)
    @invoices_customer6 = create(:invoice, customer: @customer6, status: 1)

    @invoice_items1 = create(:invoice_item, invoice: @invoices_customer1, item: @table, status: 0 ) #pending
    @invoice_items2 = create(:invoice_item, invoice: @invoices_customer2, item: @pen, status: 0 ) #pending
    @invoice_items3 = create(:invoice_item, invoice: @invoices_customer3, item: @mat, status: 1 ) #packaged
    @invoice_items4 = create(:invoice_item, invoice: @invoices_customer4, item: @mug, status: 1 ) #packaged
    @invoice_items5 = create(:invoice_item, invoice: @invoices_customer5, item: @ember, status: 2 )#shiped
    @invoice_items6 = create(:invoice_item, invoice: @invoices_customer6, item: @plant, status: 2 )#shipped
    
    @transactions_invoice1 = create_list(:transaction, 5, invoice: @invoices_customer1, result: 1)
    @transactions_invoice2 = create_list(:transaction, 4, invoice: @invoices_customer2, result: 1)
    @transactions_invoice3 = create_list(:transaction, 6, invoice: @invoices_customer3, result: 1)
    @transactions_invoice4 = create_list(:transaction, 7, invoice: @invoices_customer4, result: 1)
    @transactions_invoice5 = create_list(:transaction, 3, invoice: @invoices_customer5, result: 1)
    @transactions_invoice6 = create_list(:transaction, 9, invoice: @invoices_customer6, result: 1)
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
        @merchant1.top_five_customers.each do |customer|
          expect(page).to have_content("Customer name: #{customer.first_name} #{customer.last_name} - #{customer.transaction_count} successful transactions")
        end
      end
    end
  end

  describe "User Story 4" do
    # it "shows a section for items not shipped with its list of names" do
    #   within "#items_not_shipped-#{@merchant1.id}" do
    #       expect(page).to have_content("Items Not Shipped")
    #       expect(page).to have_content(@mat.name)
    #       expect(page).to have_content(@mug.name)
    
    #       expect(page).to have_content(@table.name)
    #       expect(page).to have_content(@pen.name)
    #       expect(page).to_not have_content(@ember.name)
    #       expect(page).to_not have_content(@plant.name)
    #   end
    # end

    it "has a link next to each unshipped invoice item titled as ID from the invoice item is on" do
      expect(page).to have_content("Items Ready to Ship")
      within "#pending_items-#{@merchant1.id}" do
        @merchant1.pending_items.each do |pending_item|
          expect(page).to have_content(pending_item.name)
          expect(page).to have_link(pending_item.invoice_id) #test doesn't recognize this.  How do I get invoice.id?
        end
      end
    end
  end
end


