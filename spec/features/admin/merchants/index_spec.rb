require "rails_helper"

RSpec.describe "the admin merchants index page" do
  before(:each) do
    @merchant_list = FactoryBot.create_list(:merchant, 3)
  end

  describe 'User Story 24' do
    it 'lists the name of each merchant' do
      visit admin_merchants_path

      within '#admin_merchant_names' do
        @merchant_list.each do |merchant|
          expect(page).to have_content(merchant.name)
        end
      end
    end
  end

  describe 'User Story 25' do
    it 'links to each merchants show page' do
      visit admin_merchants_path

      within '#admin_merchant_names' do
        @merchant_list.each do |merchant|
          expect(page).to have_link(merchant.name, href: admin_merchant_path(merchant))
        end
      end
    end
  end
end
