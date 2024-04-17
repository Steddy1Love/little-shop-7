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

    describe "User story 7a" do
      it 'has a link for each item' do
        within ".merchant_items" do
          expect(page).to have_link("#{@table.name}", href: merchant_item_path(@merchant1, @table))
          expect(page).to have_link("#{@pen.name}", href: merchant_item_path(@merchant1, @pen))
          expect(page).to have_link("#{@mat.name}", href: merchant_item_path(@merchant1, @mat))
          expect(page).to have_link("#{@mug.name}", href: merchant_item_path(@merchant1, @mug))
          expect(page).not_to have_link("#{@ember.name}", href: merchant_item_path(@merchant1, @ember))
        end

        click_link @table.name
        expect(current_path).to eq(merchant_item_path(@merchant1, @table))
      end
    end

    describe "User Story 9" do
      it "can enable/disable items" do
        @merchant1.items.each do |item|
          within "#item-#{item.id}" do
            if item.disabled? #disabled
              # Next to each item name I see a button to disable or enable that item.
              expect(page).to have_button("Enable")
              expect(page).not_to have_button("Disable")
              # When I click this button
              click_button("Enable")
              
              # Then I am redirected back to the items index
              expect(current_path).to eq(merchant_items_path(@merchant1))

              expect(page).to have_button("Disable")
              expect(page).not_to have_button("Enable")

            else
              expect(page).to have_button("Disable")
              expect(page).not_to have_button("Enable")
              
              click_button("Disable")
              
              expect(current_path).to eq(merchant_items_path(@merchant1))
              
              expect(page).to have_button("Enable")
              expect(page).not_to have_button("Disable")
            end
          end
        end
      end
    end

    describe 'User Story 10' do
      it 'displays items grouped by enabled and disabled' do
        # As a merchant,
        # When I visit my merchant items index page
        # Then I see two sections, one for "Enabled Items" and one for "Disabled Items"
        # And I see that each Item is listed in the appropriate section
        within '.enabled_items' do
          @enabled_items.each do |item|
            expect(page).to have_content(@mug.name)
            expect(page).to_not have_content(@mat.name)
          end
        end

        within '.disabled_items' do
          @disabled_items.each do |item|
            expect(page).to_not have_content(@mug.name)
            expect(page).to have_content(@mat.name)
            expect(page).to have_content(@pen.name)
            expect(page).to have_content(@table.name)
          end
        end
      end
    end
  end
end
