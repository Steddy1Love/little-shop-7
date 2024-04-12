require "rails_helper"

RSpec.describe "the admin merchants index page" do
  before(:each) do
    @merchant_list = create_list(:merchant, 3)
  end

  describe 'User Story 24' do
    it 'lists the name of each merchant' do
      visit admin_merchants_path

      within '#admin_merchants_list' do
        @merchant_list.each do |merchant|
          expect(page).to have_content(merchant.name)
        end
      end
    end
  end

  describe 'User Story 25' do
    it 'links to each merchants show page' do
      visit admin_merchants_path

      within '#admin_merchants_list' do
        @merchant_list.each do |merchant|
          expect(page).to have_link(merchant.name, href: admin_merchant_path(merchant))
        end
      end
    end
  end

  describe 'User Story 27' do
    it 'has an enable and disable button next to each merchant and when I click one of these I am redirected to the index page and see that merchants status has changed' do
      visit admin_merchants_path

      within '#admin_merchants_list' do
        @merchant_list.each do |merchant|
          within "#admin_merchant_#{merchant.id}" do
            if merchant.enabled?
              expect(page).to have_button('Disable')
              expect(page).to_not have_button('Enable')

              click_button('Disable')

              expect(current_path).to eq(admin_merchants_path)

              expect(page).to have_button('Enable')
              expect(page).to_not have_button('Disable')
            else
              expect(page).to have_button('Enable')
              expect(page).to_not have_button('Disable')

              click_button('Enable')

              expect(current_path).to eq(admin_merchants_path)

              expect(page).to have_button('Disable')
              expect(page).to_not have_button('Enable')
            end
          end
        end
      end
    end
  end

  describe 'User Story 28' do
    it 'only shows enabled merchants in the enabled merchants section and disabled merchants in the disabled merchants section' do
      enabled_merchant = create(:merchant, status: 1)
      disabled_merchant = create(:merchant, status: 0)
      visit admin_merchants_path

      within '#enabled_merchants' do
        expect(page).to have_content(enabled_merchant.name)
        expect(page).to_not have_content(disabled_merchant.name)

        @merchant_list.each do |merchant|
          expect(page).to have_content(merchant.name) if merchant.enabled?
        end
      end

      within '#disabled_merchants' do
        expect(page).to have_content(disabled_merchant.name)
        expect(page).to_not have_content(enabled_merchant.name)

        @merchant_list.each do |merchant|
          expect(page).to have_content(merchant.name) if merchant.disabled?
        end
      end
    end
  end
end
