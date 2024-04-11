require 'rails_helper'

RSpec.describe "Admin Dashboard Page", type: :feature do
  before :each do
    visit "/admin"
  end

  describe "User Story 19" do
    it "displays that this is the admin dashboard" do
      expect(page).to have_content("Admin Dashboard")
    end
  end

  describe "User Story 20" do
    it "displays links to merchants index and invoice index" do
      expect(page).to have_link("All Merchants")
      expect(page).to have_link("All Invoices")
    end
  end
end
