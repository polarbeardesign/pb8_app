require "application_system_test_case"

class CustomersTest < ApplicationSystemTestCase
  setup do
    @customer = customers(:one)
  end

  test "visiting the index" do
    visit customers_url
    assert_selector "h1", text: "Customers"
  end

  test "should create customer" do
    visit customers_url
    click_on "New customer"

    fill_in "Logo", with: @customer.logo
    fill_in "Org name", with: @customer.org_name
    fill_in "Quoted rate", with: @customer.quoted_rate
    check "Require name" if @customer.require_name
    fill_in "Reverse logo", with: @customer.reverse_logo
    fill_in "Short name", with: @customer.short_name
    fill_in "User", with: @customer.user_id
    click_on "Create Customer"

    assert_text "Customer was successfully created"
    click_on "Back"
  end

  test "should update Customer" do
    visit customer_url(@customer)
    click_on "Edit this customer", match: :first

    fill_in "Logo", with: @customer.logo
    fill_in "Org name", with: @customer.org_name
    fill_in "Quoted rate", with: @customer.quoted_rate
    check "Require name" if @customer.require_name
    fill_in "Reverse logo", with: @customer.reverse_logo
    fill_in "Short name", with: @customer.short_name
    fill_in "User", with: @customer.user_id
    click_on "Update Customer"

    assert_text "Customer was successfully updated"
    click_on "Back"
  end

  test "should destroy Customer" do
    visit customer_url(@customer)
    click_on "Destroy this customer", match: :first

    assert_text "Customer was successfully destroyed"
  end
end
