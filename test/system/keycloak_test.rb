require "application_system_test_case"

class KeycloakTest < ApplicationSystemTestCase
  test "can login" do
    visit root_path
    assert_selector "h1", text: "Sign in"
    fill_in "Username or email", with: "admin@example.com"
    fill_in "Password", with: "password"
    click_on "Continue"

    assert_text "Logged in successfully."
  end

  test "can logout" do
    visit root_path
    assert_selector "h1", text: "Sign in"
    fill_in "Username or email", with: "admin@example.com"
    fill_in "Password", with: "password"
    click_on "Continue"
    click_on "Logout"
    assert_selector "h1", text: "Sign in"
  end
end
