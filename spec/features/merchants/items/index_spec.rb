require 'rails_helper'

RSpec.describe 'Merchant Items Index' do
  before :each do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)

    @table = create(:item, name: "table", merchant: @merchant1)
    @pen = create(:item, name: "pen", merchant: @merchant1)
    @mat = create(:item, name: "yoga mat", merchant: @merchant1)
    @mug = create(:item, name: "mug", merchant: @merchant1)
    @ember = create(:item, name: "ember", merchant: @merchant2)
    @plant = create(:item, name: "plant", merchant: @merchant2)
    visit merchant_items_path(@merchant1)
  end

  describe 'User story 6' do
    # As a merchant,
    it 'displays a list of the names of a specific merchants items' do
      # When I visit my merchant items index page (merchants/:merchant_id/items)
      # I see a list of the names of all of my items
      expect(page).to have_content(@table.name)
      expect(page).to have_content(@pen.name)
      expect(page).to have_content(@mat.name)
      expect(page).to have_content(@mug.name)
      # And I do not see items for any other merchant
      expect(page).to_not have_content(@ember.name)
      expect(page).to_not have_content(@plant.name)
    end
  end
end