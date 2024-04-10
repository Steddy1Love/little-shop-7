require "rails_helper"

RSpec.describe "the admin merchants edit page" do
  before(:each) do
    @merchant_list = FactoryBot.create_list(:merchant, 3)
  end

  describe 'User Story 26' do
    it 'has a form to edit the merchants info with the existing info already filled in and
        when I click submit Im redirected to the admin merchants show page that has the updated
        info and I receive a flash message confirming the info has been updated' do
      first_merchant = @merchant_list.first

      visit edit_admin_merchant_path(first_merchant)

      expect(page).to have_selector('form')
      expect(page).to have_field(:name, with: first_merchant.name)

      fill_in(:name, with: 'Cool New Name')
      click_button('Submit')

      expect(current_path).to eq(admin_merchant_path(first_merchant))

      expect(page).to have_content('Cool New Name info updated successfully.')
      expect(page).to have_content('Cool New Name')
    end
  end
end
