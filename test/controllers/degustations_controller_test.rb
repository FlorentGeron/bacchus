require "test_helper"

class DegustationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get degustations_new_url
    assert_response :success
  end

  test "should get create" do
    get degustations_create_url
    assert_response :success
  end

  test "should get edit" do
    get degustations_edit_url
    assert_response :success
  end

  test "should get delete" do
    get degustations_delete_url
    assert_response :success
  end

  test "should get update" do
    get degustations_update_url
    assert_response :success
  end
end
