require 'rails_helper'

RSpec.describe 'Merchant_item Show page', type: :feature do
  describe 'US 7' do
    describe 'as a merchant, when I visit merchant_item_path' do
      before(:each) do
        @merchant1 = create(:merchant)
        @item = create(:item, name: "pen", description: "bic ballpoint", unit_price: 1, merchant: @merchant1)

        visit merchant_item_path(@merchant1.id, @item.id)
      end
      it 'displays item name, description, current selling price' do
        within "#item-#{@item.id}" do
          expect(page).to have_content(@item.name)
          expect(page).to have_content(@item.description)
          expect(page).to have_content(@item.unit_price)
        end
      end
    end 
  end
end