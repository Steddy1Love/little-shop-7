require 'rails_helper'

RSpec.describe "Admin Dashboard Page", type: :feature do
  before :each do
    
  end

  describe "User Story 1" do
    it "displays that this is the admin dashboard" do
      visit "/admin"

      expect(page).to have_content("Admin Dashboard")
    end
  end
end
