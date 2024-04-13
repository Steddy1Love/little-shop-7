require "rails_helper"

RSpec.describe "the admin merchants new page" do
  describe 'User Story 29' do
    it 'has a form to create a new merchant and once filled out and I click submit, I am taken back to the admin merchants index where the new merchant shows under disabled merchants' do
      visit new_admin_merchant_path

      expect(page).to have_selector('form')

      fill_in('Name:', with: 'Random Cool Merchant')
      click_button('Create Merchant')

      expect(current_path).to eq(admin_merchants_path)

      within '#disabled_merchants' do
        expect(page).to have_content('Random Cool Merchant')
      end

      within '#enabled_merchants' do
        expect(page).to_not have_content('Random Cool Merchant')
      end
    end
  end
end
