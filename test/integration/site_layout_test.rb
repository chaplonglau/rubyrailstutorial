require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    # Rails automatically inserts the value of about_path in place of the question mark (escaping any special characters if necessary), thereby checking for an HTML tag of the form <a href="/about">...</a>
    assert_select "a[href=?]", contact_path
    get contact_path
    
  end
end