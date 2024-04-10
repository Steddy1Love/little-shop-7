require "rails_helper"

RSpec.describe "the admin merchants index page" do
  before(:each) do
    @merchant_list = FactoryBot.create_list(:merchant, 3)
    @first_merchant = @merchant_list[0]
    @second_merchant = @merchant_list[1]
    @third_merchant = @merchant_list[2]

    @item_list = FactoryBot.create_list(:item, 10, merchant: @first_merchant)
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
end
