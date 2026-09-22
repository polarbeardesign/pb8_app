require "test_helper"

Capybara.register_driver :headless_chrome_no_autofill do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless")
  options.add_argument("--disable-gpu")
  options.add_argument("--window-size=1400,1400")
  # Chrome's autofill/password-save UI can intercept a synthetic click right
  # after filling a form field, causing submit clicks to silently no-op.
  options.add_preference(:credentials_enable_service, false)
  options.add_preference("profile.password_manager_enabled", false)
  options.add_argument("--disable-features=Autofill,AutofillServerCommunication")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :headless_chrome_no_autofill, screen_size: [ 1400, 1400 ]

  def submit_form(text)
    page.execute_script("document.activeElement && document.activeElement.blur()")
    # Headless Chrome occasionally swallows a click without firing any
    # request (no real bug -- confirmed working in a real browser). Keep
    # clicking, with a short pause, until the button/link is actually gone
    # (i.e. the page navigated away); has_button?/has_link? with wait: 0
    # return immediately either way, so this never waits longer than needed.
    6.times do
      click_on text
      sleep 0.3
      break unless page.has_button?(text, wait: 0) || page.has_link?(text, wait: 0)
    end
  end

  def sign_in_as(user)
    visit new_session_url
    fill_in "email_address", with: user.email_address
    fill_in "password", with: "password"
    click_on "Sign in"
    assert_no_selector "h1", text: "Log in"
  end
end
