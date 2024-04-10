require 'rails_helper'

RSpec.describe 'merchant dashboard show page', type: :feature do
  describe ' USER STORY #1' do
    describe ' as a user when I visit /merchants/:merchant_id/dashboard' do
      before(:each) do
        @merchant1 = FactoryBot.create(:merchant)    
        visit dashboard_merchant_path(@merchant1)
        #"/merchants/#{@merchant1.id}/dashboard"
        #
      end
      it 'displays' do
        # Then I see the name of my merchant
        expect(page).to have_content(@merchant1.name)
      end
    end 
  end
end