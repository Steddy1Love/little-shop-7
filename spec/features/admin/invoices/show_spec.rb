require "rails_helper"

RSpec.describe "the admin invoices show page" do
  before(:each) do
    @customer1 = create(:customer, first_name: 'Ron', last_name: 'Burgundy')
    @customer2 = create(:customer, first_name: 'Fred', last_name: 'Flintstone')
    @customer3 = create(:customer, first_name: 'Spongebob', last_name: 'SquarePants')
    @customer4 = create(:customer, first_name: 'Luffy', last_name: 'Monkey')

    @item1 = create(:item, name: "Cool Item Name")
    @item2 = create(:item)
    @item3 = create(:item)
    @item4 = create(:item)
    @item5 = create(:item)
    @item6 = create(:item)
    @item7 = create(:item)
    @item8 = create(:item)
    @item9 = create(:item)
    @item10 = create(:item)
    @item11 = create(:item)

    @invoice1 = create(:invoice, customer: @customer1, created_at: 'Mon, 15 Apr 1996 00:00:00.800830000 UTC +00:00', status: 0)
    @invoice2 = create(:invoice, customer: @customer2, created_at: 'Sun, 01 Jan 2023 00:00:00.800830000 UTC +00:00', status: 1)
    @invoice3 = create(:invoice, customer: @customer3, created_at: 'Sun, 17 Mar 2024 00:00:00.800830000 UTC +00:00', status: 2)
    @invoice4 = create(:invoice, customer: @customer4, created_at: 'Sat, 16 Mar 2024 00:00:00.800830000 UTC +00:00', status: 1)
    @invoice5 = create(:invoice, customer: @customer1, created_at: 'Tue, 25 Jun 1997 00:00:00.800830000 UTC +00:00', status: 0)

    create(:invoice_item, item: @item1, invoice: @invoice1, quantity: 10, unit_price: 5000, status: 2)
    create(:invoice_item, item: @item2, invoice: @invoice1, quantity: 3, unit_price: 55000, status: 1)
    create(:invoice_item, item: @item8, invoice: @invoice1, quantity: 8, unit_price: 41000, status: 0)
    create(:invoice_item, item: @item5, invoice: @invoice1, quantity: 4, unit_price: 1000, status: 2)
    create(:invoice_item, item: @item3, invoice: @invoice2, quantity: 5, unit_price: 2000, status: 2)
    create(:invoice_item, item: @item4, invoice: @invoice2, quantity: 5, unit_price: 5050, status: 1)
    create(:invoice_item, item: @item3, invoice: @invoice3, quantity: 1, unit_price: 400000, status: 0)
    create(:invoice_item, item: @item11, invoice: @invoice4, quantity: 1, unit_price: 1000, status: 2)
    create(:invoice_item, item: @item10, invoice: @invoice4, quantity: 5, unit_price: 5000, status: 2)
    create(:invoice_item, item: @item9, invoice: @invoice4, quantity: 3, unit_price: 2000, status: 1)
    create(:invoice_item, item: @item1, invoice: @invoice5, quantity: 6, unit_price: 5100, status: 0)
    create(:invoice_item, item: @item2, invoice: @invoice5, quantity: 8, unit_price: 4500, status: 1)
  end

  describe 'User Story 33' do
    it 'lists all invoice IDs in the system and each ID links to the admin invoice show page' do
      visit admin_invoice_path(@invoice1)

      expect(page).to have_content("Invoice ##{@invoice1.id}")
      expect(page).to have_content("Status: in progress")
      expect(page).to have_content("Created on: Monday, April 15, 1996")
      expect(page).to have_content("Customer: Ron Burgundy")

      expect(page).to_not have_content("Invoice ##{@invoice2.id}")
      expect(page).to_not have_content("Customer: Fred Flintstone")
    end
  end

  describe 'User Story 34' do
    it 'lists all of the items for that invoice including their name, quantity ordered, price sold for and status' do
      visit admin_invoice_path(@invoice1)

      within '#admin_invoice_items' do
        expect(page).to have_content("Item Name: Cool Item Name")
        expect(page).to have_content("Quantity: 10")
        expect(page).to have_content("Unit Price: 5000")
        expect(page).to have_content("Status: Shipped")

        @invoice1.invoice_items.each do |invoice_item|
          within "#invoice_item_#{invoice_item.id}_info" do
            expect(page).to have_content("Item Name: #{invoice_item.item.name}")
            expect(page).to have_content("Quantity: #{invoice_item.quantity}")
            expect(page).to have_content("Unit Price: #{invoice_item.unit_price}")
            expect(page).to have_content("Status: #{invoice_item.status.capitalize}")
          end
        end
      end
    end
  end
end