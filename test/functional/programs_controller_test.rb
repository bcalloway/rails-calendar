require 'test_helper'

class ProgramsControllerTest < ActionController::TestCase
  
  setup :activate_authlogic
  
  context "On GET for index" do
    setup do
      get :index
    end
  
    should_respond_with :success
    should_render_with_layout 'comatose_admin'
    should_render_template :index
  end

  context "On GET for new" do
    setup do
      get :new
    end
  
    should_respond_with :success
    should_render_with_layout 'comatose_admin'
    should_render_template :new
  end

  context "On failed UPDATE" do
    setup do
      Program.any_instance.stubs(:save).returns(false)
      put :update, :id => Factory(:program).to_param, :program => {}
    end
    should_render_template :edit
  end
  
  context "On failed CREATE" do
    setup do
      post :create, :name => 'my program'
    end
    
    should_change("number of programs", :by => 0) { Program.count }
    should_render_template :new
  end

  test "should create program" do
    assert_difference('Program.count') do
      post :create, :program=> {:name => 'Special'}
    end

    assert_redirected_to "/programs"
    assigns :program
  end
  

  test "should show program" do
    get :show, :id => Factory(:program).id
    assert_response :redirect
  end

  test "should get edit" do
    get :edit, :id => Factory(:program).id
    assert_response :success
  end

  test "should update program" do
    put :update, :id => Factory(:program).to_param, :program => { }
    assert_redirected_to "/programs"
    assigns(:program)
  end

  test "should destroy program" do
    @program = Factory.create(:program, :name => "old")
    assert_difference('Program.count', -1) do
      delete :destroy, :id => @program.id
    end

    assert_redirected_to "/programs"
  end
end
