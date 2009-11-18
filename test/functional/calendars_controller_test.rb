require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase
  
  setup :activate_authlogic
  
  context "On event EXPORT" do
    context "of a single event" do
      setup do
        get :export_event, :id => Factory(:calendar).id
      end
      
      should_respond_with :success
      should_respond_with_content_type 'text/calendar'
    end
  
    context "of daily events" do
      setup do
        get :export_daily_events, :id => Time.now.strftime('%Y-%m-%d')
      end
      
      should_respond_with :success
      should_respond_with_content_type 'text/calendar'
    end
    
    context "of all events" do
      setup do
        get :export_events, :id => Time.now.strftime('%Y-%m-%d')
      end
      
      should_respond_with :success      
      should_respond_with_content_type 'text/calendar'
    end
    
    context "of events from selected programs" do
      setup do
        get :export_selected_events, :program => 1, :id => Time.now.strftime('%Y-%m-%d')
      end
      
      should_respond_with :success      
      should_respond_with_content_type 'text/calendar'
    end
  end

  context "When subscribing to the feed for all calendar events" do
    setup do
      get :subscribe
    end
    
    should_respond_with :success      
    should_respond_with_content_type 'text/calendar'
  end
  
  context "On GET for all calendars" do
    setup do
      get :calendar_list, :id => Time.now.strftime('%Y-%m-%d'), :program => ["1"]
    end
    
    should_respond_with :success
    should_render_template :calendar
    should_render_with_layout 'application'
  end
  
  context "On GET for daily calendars" do
    setup do
      get :daily_list, :id => Time.now.strftime('%Y-%m-%d')
    end
    
    should_respond_with :success
    should_render_template :calendar
    should_render_with_layout 'application'
  end
  
  # context "On GET for calendar category" do
  #   context "if a category is provided" do
  #     setup do
  #       get :filter, :id => '2009-11-20', :program => 1
  #     end
  #   
  #     should_respond_with :success
  #     should_render_template :calendar
  #     should_render_with_layout 'application'
  #   end
  # 
  #   context "if no specified category" do
  #     setup do
  #       get :filter, :id => '2009-11-20', :category => nil
  #     end
  #   
  #     should_respond_with :success
  #     should_render_template :calendar
  #     should_render_with_layout 'application'
  #   end
  # end

  context "On failed UPDATE" do
    setup do
      Calendar.any_instance.stubs(:save).returns(false)
      put :update, :id => Factory(:calendar).to_param, :calendar => {}
    end
    
    should_render_template :edit
  end
  
  context "On failed CREATE" do
    setup do
      post :create, :calendar => {
                    :event => nil,
                    :description => 'none',
                    :start_date => '2009-11-24',
                    :end_date => '2009-11-24',
                    :program_id => Factory(:program, :name => 'Special').id
                    }
    end
    
    should_not_change("number of calendars") { Calendar.count }
    should_render_template :new
  end

  context "On INDEX" do
    setup do
      get :index
    end
    
    should_respond_with :success
    should_render_with_layout :comatose_admin
    should_render_template :index
  end
  
  context "On NEW" do
    setup do
      get :new
    end

    should_respond_with :success
    should_render_with_layout :comatose_admin
    should_render_template :new
  end
  
  context "On CREATE" do
    setup do
      post :create, :calendar => {
                    :event => 'Away Game',
                    :description => 'A match that is far, far away',
                    :start_date => '2009-11-24',
                    :end_date => '2009-11-24',
                    :program_id => Factory(:program, :name => 'Special').id
                    }
    end
    
    should_change("Number of events") { Calendar.count }
    should_set_the_flash_to "Calendar was successfully created."
    should_redirect_to('Calendar list') { '/calendars' }
  end
  
  context "On EDIT" do
    setup do
      get :edit, :id => Factory(:calendar).id
    end

    should_respond_with :success
    should_render_with_layout :comatose_admin
    should_render_template :edit
  end

  context "On UPDATE" do
    setup do
      put :update, :id => Factory(:calendar).to_param, :calendar => { }
    end
  
    should_set_the_flash_to "Calendar was successfully updated."
    should_redirect_to('Calendar list') { '/calendars' }
  end

  context "On DESTROY" do
    setup do
      @event = Factory(:calendar, :event => 'Old Event', :description => 'An event that needs to be deleted', :start_date => '2009-11-24', :end_date => '2009-11-24')
      post :destroy, :id => @event.id
    end
    
    should_set_the_flash_to "Calendar event has been deleted."
    should_redirect_to("Calendar list") { '/calendars' }
  end
  
  context "When deleting an event" do
    setup do
      @event = Factory(:calendar, :event => 'Old Event', :description => 'An event that needs to be deleted', :start_date => '2009-11-24', :end_date => '2009-11-24')
    end
    
    should "destroy event" do
      assert_difference('Calendar.count', -1) do
        post :destroy, :id => @event.id
      end
    end
  end
  
end
