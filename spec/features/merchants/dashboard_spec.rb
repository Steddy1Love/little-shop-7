require 'rails_helper'

RSpec.describe 'merchant dashboard show page', type: :feature do
  before(:each) do
    @merchant1 = FactoryBot.create(:merchant)
    @merchant2 = FactoryBot.create(:merchant)

    @table = FactoryBot.create(:item, name: "table", merchant: @merchant1)
    @pen = FactoryBot.create(:item, name: "pen", merchant: @merchant1)
    @mat = FactoryBot.create(:item, name: "yoga mat", merchant: @merchant1)
    @mug = FactoryBot.create(:item, name: "mug", merchant: @merchant1)
    @ember = FactoryBot.create(:item, name: "ember", merchant: @merchant1)
    @plant = FactoryBot.create(:item, name: "plant", merchant: @merchant1)
    @plant2 = FactoryBot.create(:item, name: "Orchid", merchant: @merchant2)
    @pooltoy = FactoryBot.create(:item, name: "Pool noodle", merchant: @merchant2)
    @bear = FactoryBot.create(:item, name: "Teddy bear", merchant: @merchant2)
    @ball = FactoryBot.create(:item, name: "baseball", merchant: @merchant2)
    @scent = FactoryBot.create(:item, name: "perfume", merchant: @merchant2)
    @tool = FactoryBot.create(:item, name: "screwdriver", merchant: @merchant2)

    @customer1 = create(:customer)
    @customer2 = create(:customer)
    @customer3 = create(:customer)
    @customer4 = create(:customer)
    @customer5 = create(:customer)
    @customer6 = create(:customer)

    @coupon1 = Coupon.create(name: "BOGO50", code: "BOGO50M1", percent_off: 50, dollar_off: nil, merchant_id: @merchant1.id)
    @coupon2 = Coupon.create(name: "10OFF", code: "10OFFM1", percent_off: 10, dollar_off: nil, merchant_id: @merchant1.id)
    @coupon3 = Coupon.create(name: "20BUCKS", code: "20OFFM1", percent_off: nil, dollar_off: 2000, merchant_id: @merchant1.id)
    @coupon4 = Coupon.create(name: "BOGO50", code: "BOGO50M2", percent_off: 50, dollar_off: nil, merchant_id: @merchant2.id)
    @coupon5 = Coupon.create(name: "10OFF", code: "10OFFM2", percent_off: 10, dollar_off: nil, merchant_id: @merchant2.id)
    @coupon6 = Coupon.create(name: "20BUCKS", code: "20OFFM2", percent_off: nil, dollar_off: 2000, merchant_id: @merchant2.id)

    @invoices_customer1 = create(:invoice, customer: @customer1, coupon_id: @coupon1.id, status: 1)
    @invoices_customer2 = create(:invoice, customer: @customer2, coupon_id: @coupon2.id, status: 1)
    @invoices_customer3 = create(:invoice, customer: @customer3, coupon_id: @coupon3.id, status: 1)
    @invoices_customer4 = create(:invoice, customer: @customer4, coupon_id: @coupon4.id, status: 1)
    @invoices_customer5 = create(:invoice, customer: @customer5, coupon_id: @coupon5.id, status: 1)
    @invoices_customer6 = create(:invoice, customer: @customer6, coupon_id: @coupon6.id, status: 1)

    @invoice_items1 = create(:invoice_item, invoice: @invoices_customer1, item: @table, status: 0 ) #pending
    @invoice_items2 = create(:invoice_item, invoice: @invoices_customer2, item: @pen, status: 0 ) #pending
    @invoice_items3 = create(:invoice_item, invoice: @invoices_customer3, item: @mat, status: 1 ) #packaged
    @invoice_items4 = create(:invoice_item, invoice: @invoices_customer4, item: @mug, status: 1 ) #packaged
    @invoice_items5 = create(:invoice_item, invoice: @invoices_customer5, item: @plant2, status: 1 ) #packaged
    @invoice_items6 = create(:invoice_item, invoice: @invoices_customer6, item: @ball, status: 2 )#shiped
    @invoice_items7 = create(:invoice_item, invoice: @invoices_customer6, item: @scent, status: 2 )#shipped
    
    @transactions_invoice1 = create_list(:transaction, 5, invoice: @invoices_customer1, result: 1)
    @transactions_invoice2 = create_list(:transaction, 4, invoice: @invoices_customer2, result: 1)
    @transactions_invoice3 = create_list(:transaction, 6, invoice: @invoices_customer3, result: 1)
    @transactions_invoice4 = create_list(:transaction, 7, invoice: @invoices_customer4, result: 1)
    @transactions_invoice5 = create_list(:transaction, 3, invoice: @invoices_customer5, result: 1)
    @transactions_invoice6 = create_list(:transaction, 9, invoice: @invoices_customer6, result: 1)

    visit dashboard_merchant_path(@merchant1)
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
      expect(page).to have_link("My Items", href: merchant_items_path(@merchant1))
      expect(page).to have_link("My Invoices", href: merchant_invoices_path(@merchant1))
    end
  end

  describe 'User Story 3' do
    it 'shows the names of the top 5 customers with the largest number of successful transactions' do
      within '.top5' do
        @merchant1.top_five_customers.each do |customer|
          expect(page).to have_content("Customer name: #{customer.first_name} #{customer.last_name} - #{customer.transaction_count} successful transactions")
        end
      end
    end
  end

  describe "User Story 4" do # Would like to refactor this hardcoded so nested within blocks isn't so visually taxing"
    it "has a link next to each packaged invoice item titled as ID from the invoice item is on" do
      expect(page).to have_content("Items Ready to Ship")
      within "#packaged_items-#{@merchant1.id}" do
        @merchant1.packaged_items.each do |packaged_item|
          expect(page).to have_content(packaged_item.item.name)
          expect(page).to have_link(packaged_item.invoice_id.to_s, href: merchant_invoice_path(@merchant1, packaged_item.invoice_id)) 
        end
      end
    end
  end

  describe "US 5" do
    it "displays created_at date ordered by oldest first" do
      within "#packaged_items-#{@merchant1.id}" do
        save_and_open_page
        @merchant1.packaged_items.each do |packaged_item|
          expect(@merchant1.formatted_date(packaged_item.created_at)).to match(/\A[A-Z][a-z]+, [A-Z][a-z]+ \d{1,2}, \d{4}\z/)
          expect("yoga mat").to appear_before("mug")
        end
      end
    end
  end

  describe "US 1 FS pt 1" do
    it "Shows a link to the coupons' index page" do
      within '.coupons_link'
      expect(page).to have_link("All Coupons", href: merchant_coupons_path)
      click_link("All Coupons")
      expect(current_path).to eq(merchant_coupons_path)
    end
  end
end