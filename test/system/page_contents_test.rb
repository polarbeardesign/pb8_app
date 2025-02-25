require "application_system_test_case"

class PageContentsTest < ApplicationSystemTestCase
  setup do
    @page_content = page_contents(:one)
  end

  test "visiting the index" do
    visit page_contents_url
    assert_selector "h1", text: "Page contents"
  end

  test "should create page content" do
    visit page_contents_url
    click_on "New page content"

    fill_in "Copy", with: @page_content.copy
    fill_in "Title", with: @page_content.title
    click_on "Create Page content"

    assert_text "Page content was successfully created"
    click_on "Back"
  end

  test "should update Page content" do
    visit page_content_url(@page_content)
    click_on "Edit this page content", match: :first

    fill_in "Copy", with: @page_content.copy
    fill_in "Title", with: @page_content.title
    click_on "Update Page content"

    assert_text "Page content was successfully updated"
    click_on "Back"
  end

  test "should destroy Page content" do
    visit page_content_url(@page_content)
    click_on "Destroy this page content", match: :first

    assert_text "Page content was successfully destroyed"
  end
end
