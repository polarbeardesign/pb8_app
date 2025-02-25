require "application_system_test_case"

class NoteCategoriesTest < ApplicationSystemTestCase
  setup do
    @note_category = note_categories(:one)
  end

  test "visiting the index" do
    visit note_categories_url
    assert_selector "h1", text: "Note categories"
  end

  test "should create note category" do
    visit note_categories_url
    click_on "New note category"

    fill_in "Category name", with: @note_category.category_name
    click_on "Create Note category"

    assert_text "Note category was successfully created"
    click_on "Back"
  end

  test "should update Note category" do
    visit note_category_url(@note_category)
    click_on "Edit this note category", match: :first

    fill_in "Category name", with: @note_category.category_name
    click_on "Update Note category"

    assert_text "Note category was successfully updated"
    click_on "Back"
  end

  test "should destroy Note category" do
    visit note_category_url(@note_category)
    click_on "Destroy this note category", match: :first

    assert_text "Note category was successfully destroyed"
  end
end
