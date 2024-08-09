require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
    @product1 = products(:one)
    @product2 = products(:two)
    @user = users(:one)
  end

  test "should get index when authenticated" do
    post user_session_url, params: { user: { email: @user.email, password: '123456' } }
    get orders_url
    assert_response :success
  end

  test 'filters' do
    post user_session_url, params: { user: { email: @user.email, password: '123456' } }
    post orders_url, params: { order: { product_id: @product1.id, customer_name: 'Name' } }
    order1 = Order.last
    post orders_url, params: { order: { product_id: @product2.id, customer_name: 'Other' } }
    order2 = Order.last
    get orders_url, params: { filters: { customer_name: 'Name' } }
    assert_response :success
    assert_select "#order_#{order2.id}", false
    get orders_url, params: { filters: { product_id: @product2.id } }
    assert_select "#order_#{order1.id}", false
  end

  test "should block access to get index when no authenticated" do
    get orders_url
    assert_redirected_to user_session_url
  end

  test "should get new" do
    get new_order_url
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.processing.count') do
      post orders_url, params: { order: { product_id: @order.product.id, customer_name: "Name" } }
    end

    assert_redirected_to order_url(Order.last)
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_url(@order)
    assert_response :success
  end

  test "should update order" do
    patch order_url(@order), params: { order: { product_id: @order.product.id, customer_name: "Name" } }
    assert_redirected_to order_url(@order)
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
  end
end
