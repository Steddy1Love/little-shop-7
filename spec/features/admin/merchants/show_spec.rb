require "rails_helper"

RSpec.describe "the admin merchants show page" do
  before(:each) do
    @merchant_list = FactoryBot.create_list(:merchant, 3)
  end

  describe 'User Story 25' do
    it 'shows the name of the merchant' do
      first_merchant = @merchant_list.first
      second_merchant = @merchant_list.second

      visit admin_merchant_path(first_merchant)

      expect(page).to have_content(first_merchant.name)

      visit admin_merchant_path(second_merchant)

      expect(page).to have_content(second_merchant.name)
    end
  end

  describe 'User Story 26' do
    it 'has a link to the merchants edit page' do
      first_merchant = @merchant_list.first
      second_merchant = @merchant_list.second

      visit admin_merchant_path(first_merchant)

      expect(page).to have_link("Update #{first_merchant.name}", href: edit_admin_merchant_path(first_merchant))

      visit admin_merchant_path(second_merchant)

      expect(page).to have_link("Update #{second_merchant.name}", href: edit_admin_merchant_path(second_merchant))
    end
  end

  
end
