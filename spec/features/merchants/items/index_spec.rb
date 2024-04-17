require 'rails_helper'

RSpec.describe 'Merchant Items Index' do
  before :each do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)

    @table = create(:item, name: "table", merchant: @merchant1, status: 0)
    @pen = create(:item, name: "pen", merchant: @merchant1, status: 0)
    @mat = create(:item, name: "yoga mat", merchant: @merchant1, status: 0)
    @mug = create(:item, name: "mug", merchant: @merchant1, status: 1)
    @ember = create(:item, name: "ember", merchant: @merchant2, status: 1)
    @plant = create(:item, name: "plant", merchant: @merchant2, status: 1)

    visit merchant_items_path(@merchant1)
  end

  describe 'User story 6' do
    it 'displays a list of the names of a specific merchants items' do
      expect(page).to have_content(@table.name)
      expect(page).to have_content(@pen.name)
      expect(page).to have_content(@mat.name)
      expect(page).to have_content(@mug.name)
      
      expect(page).to_not have_content(@ember.name)
      expect(page).to_not have_content(@plant.name)
    end
  end

  describe "User story 7a" do
    it 'has a link for each item' do
      expect(page).to have_link("#{@mug.name}", href: merchant_item_path(@merchant1, @mug))
      expect(page).to have_link("#{@table.name}", href: merchant_item_path(@merchant1, @table))
      expect(page).to have_link("#{@pen.name}", href: merchant_item_path(@merchant1, @pen))
      expect(page).to have_link("#{@mat.name}", href: merchant_item_path(@merchant1, @mat))
      expect(page).not_to have_link("#{@ember.name}", href: merchant_item_path(@merchant1, @ember))

      click_link @table.name
      expect(current_path).to eq(merchant_item_path(@merchant1, @table))
    end
  end

  describe "User Story 9" do
    it "can enable/disable items" do
      within ".enabled_items .enabled_item-#{@mug.id}" do
        expect(page).to have_content(@mug.name)
        expect(page).to have_button("Disable #{@mug.name}")
        expect(page).to_not have_button("Enable #{@mat.name}")
        click_button("Disable #{@mug.name}")
        expect(current_path).to eq(merchant_items_path(@merchant1))
      end

      within ".enabled_items" do
        expect(page).to_not have_content(@mug.name)
      end

      within ".disabled_items .disabled_item-#{@pen.id}" do
        expect(page).to have_content(@pen.name)
        expect(page).to have_button("Enable #{@pen.name}")
        expect(page).to_not have_button("Disable #{@pen.name}")
        click_button("Enable #{@pen.name}")
        expect(current_path).to eq(merchant_items_path(@merchant1))
      end
      
      within ".disabled_items" do
        expect(page).to_not have_content(@pen.name)
      end
    end
  end
     
  describe 'User Story 10' do
    it 'displays items grouped by enabled and disabled' do
      within '.enabled_items' do
        @merchant1.items.enabled.each do |item|
          expect(page).to have_content(@mug.name)
          expect(page).to_not have_content(@mat.name)
        end
      end
      
      within '.disabled_items' do
        @merchant1.items.each do |item|
          expect(page).to_not have_content(@mug.name)
          expect(page).to have_content(@mat.name)
          expect(page).to have_content(@pen.name)
          expect(page).to have_content(@table.name)
        end
      end
    end
  end
end
