require 'rails_helper'

RSpec.describe 'merchant dashboard show page', type: :feature do
  before(:each) do
        @merchant1 = FactoryBot.create(:merchant)    
        visit dashboard_merchant_path(@merchant1)
        #"/merchants/#{@merchant1.id}/dashboard"
        #
  end

  describe ' USER STORY #1' do
    describe ' as a user when I visit /merchants/:merchant_id/dashboard' do
      
      it 'displays' do
        # Then I see the name of my merchant
        expect(page).to have_content(@merchant1.name)
      end
    end 
  end

  describe 'User Story 2' do
    it 'has links for merchant items index and invoices index' do
      # As a merchant,
      # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
      # Then I see link to my merchant items index (/merchants/:merchant_id/items)
      expect(page).to have_link("Merchant Items")
      # And I see a link to my merchant invoices index (/merchants/:merchant_id/invoices)
      expect(page).to have_link("Merchant Invoices")
    end
  end
end