require "application_system_test_case"

class InvoicesTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:one)
    @invoice = invoices(:one)
  end

  test "visiting the index" do
    visit invoices_url
    assert_selector "h1", text: "Invoices"
  end

  test "should create invoice" do
    visit invoices_url
    click_on "New invoice"

    fill_in "Button code", with: @invoice.button_code
    select @invoice.customer.short_name, from: "Customer", match: :first
    fill_in "Invoice date", with: @invoice.invoice_date
    fill_in "Invoice number", with: @invoice.invoice_number
    check "Paid" if @invoice.paid
    fill_in "Pdf address", with: @invoice.pdf_address
    fill_in "Tax amount", with: @invoice.tax_amount
    fill_in "Total amount", with: @invoice.total_amount
    submit_form "Create Invoice"

    assert_text "Invoice was successfully created"
    click_on "Back"
  end

  test "should update Invoice" do
    visit invoice_url(@invoice)
    click_on "Edit this invoice", match: :first

    fill_in "Button code", with: @invoice.button_code
    select @invoice.customer.short_name, from: "Customer", match: :first
    fill_in "Invoice date", with: @invoice.invoice_date
    fill_in "Invoice number", with: @invoice.invoice_number
    check "Paid" if @invoice.paid
    fill_in "Pdf address", with: @invoice.pdf_address
    fill_in "Tax amount", with: @invoice.tax_amount
    fill_in "Total amount", with: @invoice.total_amount
    submit_form "Update Invoice"

    assert_text "Invoice was successfully updated"
    click_on "Back"
  end

  test "should destroy Invoice" do
    visit invoice_url(@invoice)
    submit_form "Destroy this invoice"

    assert_text "Invoice was successfully destroyed"
  end
end
