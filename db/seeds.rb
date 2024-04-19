# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Merchant.destroy_all 
@merchant1 = create(:merchant) 
@merchant2 = create(:merchant)

@table = create(:item, name: "table", merchant: @merchant1)
@pen = create(:item, name: "pen", merchant: @merchant1)
@mat = create(:item, name: "yoga mat", merchant: @merchant1)
@mug = create(:item, name: "mug", merchant: @merchant1)
@ember = create(:item, name: "ember", merchant: @merchant1)
@plant = create(:item, name: "plant", merchant: @merchant1)
@plant2 = create(:item, name: "Orchid", merchant: @merchant2)
@pooltoy = create(:item, name: "Pool noodle", merchant: @merchant2)
@bear = create(:item, name: "Teddy bear", merchant: @merchant2)
@ball = create(:item, name: "baseball", merchant: @merchant2)
@scent = create(:item, name: "perfume", merchant: @merchant2)
@tool = create(:item, name: "screwdriver", merchant: @merchant2)


@customer1 = create(:customer)
@customer2 = create(:customer)
@customer3 = create(:customer)
@customer4 = create(:customer)
@customer5 = create(:customer)
@customer6 = create(:customer)

@coupon1 = Coupon.create(name: "BOGO50", code: "BOGO50M1", percent_off: 50, dollar_off: nil, merchant_id: @merchant1.id)
@coupon2 = Coupon.create(name: "10OFF", code: "10OFFM1", percent_off: 10, dollar_off: nil, merchant_id: @merchant1.id)
@coupon3 = Coupon.create(name: "20BUCKS", code: "20OFFM1", percent_off: nil, dollar_off: 2000, merchant_id: @merchant1.id)
@coupon4 = Coupon.create(name: "BOGO50", code: "BOGO50M2", percent_off: 50, dollar_off: nil, merchant_id: @merchant2.id)
@coupon5 = Coupon.create(name: "10OFF", code: "10OFFM2", percent_off: 10, dollar_off: nil, merchant_id: @merchant2.id)
@coupon6 = Coupon.create(name: "20BUCKS", code: "20OFFM2", percent_off: nil, dollar_off: 2000, merchant_id: @merchant2.id)


@invoice1 = create(:invoice, customer: @customer1, status: 1, coupon_id: @coupon1.id)
@invoice2 = create(:invoice, customer: @customer2, status: 1, coupon_id: @coupon2.id)
@invoice3 = create(:invoice, customer: @customer3, status: 1, coupon_id: @coupon3.id)
@invoice4 = create(:invoice, customer: @customer4, status: 1, coupon_id: @coupon4.id)
@invoice5 = create(:invoice, customer: @customer5, status: 1, coupon_id: @coupon5.id)
@invoice6 = create(:invoice, customer: @customer6, status: 1, coupon_id: @coupon6.id)

@invoice_items1 = create(:invoice_item, invoice: @invoices_customer1, item: @table, status: 0 ) #pending
@invoice_items1 = create(:invoice_item, invoice: @invoices_customer1, item: @plant2, status: 0 ) #pending
@invoice_items2 = create(:invoice_item, invoice: @invoices_customer2, item: @pen, status: 0 ) #pending
@invoice_items3 = create(:invoice_item, invoice: @invoices_customer3, item: @mat, status: 1 ) #packaged
@invoice_items4 = create(:invoice_item, invoice: @invoices_customer4, item: @plant2, status: 1 ) #packaged
@invoice_items5 = create(:invoice_item, invoice: @invoices_customer5, item: @ball, status: 2 )#shiped
@invoice_items6 = create(:invoice_item, invoice: @invoices_customer6, item: @scent, status: 2 )#shipped

@transactions_invoice1 = create_list(:transaction, 5, invoice: @invoices_customer1, result: 1)
@transactions_invoice2 = create_list(:transaction, 4, invoice: @invoices_customer2, result: 1)
@transactions_invoice3 = create_list(:transaction, 6, invoice: @invoices_customer3, result: 1)
@transactions_invoice4 = create_list(:transaction, 7, invoice: @invoices_customer4, result: 1)
@transactions_invoice5 = create_list(:transaction, 3, invoice: @invoices_customer5, result: 1)
@transactions_invoice6 = create_list(:transaction, 9, invoice: @invoices_customer6, result: 1)