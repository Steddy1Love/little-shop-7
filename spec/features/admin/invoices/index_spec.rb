require "rails_helper"

RSpec.describe "the admin invoices index page" do
  before(:each) do
    @invoice1 = create(:invoice)
    @invoice2 = create(:invoice)
    @invoice3 = create(:invoice)
    @invoice4 = create(:invoice)
    @invoice5 = create(:invoice)
  end

  describe 'User Story 32' do
    it 'lists all invoice IDs in the system and each ID links to the admin invoice show page' do
      visit admin_invoices_path

      Invoice.all.each do |invoice|
        expect(page).to have_content(invoice.id)
        expect(page).to have_link("Invoice ##{invoice.id}", href: admin_invoice_path(invoice))
      end
    end
  end
end