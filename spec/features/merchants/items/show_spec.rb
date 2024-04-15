require 'rails_helper'

RSpec.describe 'Merchant Items Index' do
  before :each do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)

    @table = create(:item, name: "table", merchant: @merchant1)
    @pen = create(:item, name: "pen", merchant: @merchant2)


    visit merchant_item_path(@merchant1, @table)
  end

  describe 'User story 7b' do
    it 'displays item attributes' do
      # And I see all of the item's attributes including:
        expect(page).to have_content(@table.name)
        expect(page).to have_content(@table.description)
        expect(page).to have_content(@table.unit_price)
        expect(page).to_not have_content(@pen.name)
    end
  end
end
