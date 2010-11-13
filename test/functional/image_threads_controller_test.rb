require 'test_helper'

class ImageThreadsControllerTest < ActionController::TestCase
  setup do
    @image_thread = image_threads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:image_threads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create image_thread" do
    assert_difference('ImageThread.count') do
      post :create, :image_thread => @image_thread.attributes
    end

    assert_redirected_to image_thread_path(assigns(:image_thread))
  end

  test "should show image_thread" do
    get :show, :id => @image_thread.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @image_thread.to_param
    assert_response :success
  end

  test "should update image_thread" do
    put :update, :id => @image_thread.to_param, :image_thread => @image_thread.attributes
    assert_redirected_to image_thread_path(assigns(:image_thread))
  end

  test "should destroy image_thread" do
    assert_difference('ImageThread.count', -1) do
      delete :destroy, :id => @image_thread.to_param
    end

    assert_redirected_to image_threads_path
  end
end
