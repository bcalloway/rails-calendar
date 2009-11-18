require 'icalendar'

class CalendarsController < ApplicationController
  
  layout 'admin'
  
  def index
    @calendars = Calendar.all_events(params[:page])

    respond_to do |format|
      format.html
    end
  end

  def show
    @calendar = Calendar.find(params[:id])

    render :layout => false
  end

  def new
    @calendar = Calendar.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @calendar = Calendar.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def create
    @calendar = Calendar.create(params[:calendar])

    respond_to do |format|
      if @calendar.save
        flash[:notice] = 'Calendar was successfully created.'
        format.html { redirect_to("/calendars") }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @calendar = Calendar.find(params[:id])

    respond_to do |format|
      if @calendar.update_attributes(params[:calendar])
        flash[:notice] = 'Calendar was successfully updated.'
        format.html { redirect_to("/calendars") }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @calendar = Calendar.find(params[:id])

    @calendar.destroy

    respond_to do |format|
      flash[:notice] = 'Calendar event has been deleted.'
      format.html { redirect_to("/calendars") }
    end
  end
  
  # show end-user view of calendar
  def calendar_list
    @events = Calendar.current_events(params[:id])
    @daily_events = @events.group_by { |d| d.start_date }

    respond_to do |format|
      format.html{ render :layout => 'application' }
    end
  end

  # show all events for the chosen day
  def daily_list
    @events = Calendar.day_events(params[:id])
    @daily_events = @events.group_by { |d| d.start_date }

    respond_to do |format|
      format.html{ render :layout => 'application' }
    end
  end

  # show calendar for the chosen programs
  def programs
    start = DateTime.strptime("#{params[:id]}T00:00:00+00:00")
    month = start.strftime("%Y-%m")
    
    if params[:program]
      @events = Calendar.filter_events(params[:program], month)
      
      @daily_events = @events.group_by { |d| d.start_date }
    else
      @events = Calendar.current_events(month)
      @daily_events = @events.group_by { |d| d.start_date }
    end
  end

  def filter
    self.programs

    respond_to do |format|
      format.html {render :layout => 'application', :template => "/calendars/calendar_list"}
    end
  end

  def show
    @calendar = Calendar.find(params[:id])

    render :layout => false
  end


  # Build the ical file from @events
  def build_ical
    @calendar = Icalendar::Calendar.new

    for cal in @events
      event = Icalendar::Event.new
      event.start = cal.start_date.strftime("%Y%m%dT%H%M%S")
      event.end = cal.end_date.strftime("%Y%m%dT%H%M%S")
      event.summary = cal.event
      event.description = cal.description
      #event.location = cal.location
      @calendar.add event
    end    

    @calendar.publish

    send_data(@calendar.to_ical, :type => 'text/calendar', :filename => 'ical.ics')
  end

  # Subscribe to an ics feed for the entire calendar
  def subscribe
    @events = Calendar.all

    respond_to do |format|
      format.ics  { render :text => self.subscribe_events}
    end
  end

  # Subscribe to iCal feed of selected categories
  def subscribe_selected
    start = DateTime.strptime("#{params[:id]}T00:00:00+00:00")
    month = start.strftime("%Y-%m-01")

    prog = params[:program]
    prog = prog.split(",")

    @events = Calendar.filter_events(prog, month)
    
    respond_to do |format|
      format.ics  { render :text => self.subscribe_events}
    end
  end
    
  # Subscribe to iCal feed of all events
  def subscribe_events
    @calendar = Icalendar::Calendar.new

    for cal in @events
      event = Icalendar::Event.new
      event.start = cal.start_date.strftime("%Y%m%dT%H%M%S")
      event.end = cal.end_date.strftime("%Y%m%dT%H%M%S")
      event.summary = cal.event
      event.description = cal.description
      #event.location = cal.location
      @calendar.add event
    end    

    @calendar.publish
    @calendar.to_ical
  end
  
  # Export all events as an ics file
  def export_events    
    @events = Calendar.current_events(params[:id])
    self.build_ical
  end

  # Export all events on the chosen day as an ics file
  def export_daily_events    
    @events = Calendar.day_events(params[:id])
    self.build_ical
  end

  # Export all events from selected categories as an ics file
  def export_selected_events
    start = DateTime.strptime("#{params[:id]}T00:00:00+00:00")
    month = start.strftime("%Y-%m-01")
    
    prog = params[:program]
    prog = prog.split(",")

    @events = Calendar.filter_events(prog, month)
    
    self.build_ical
  end

  # Export a single event as an ics file
  def export_event
    @event = Calendar.find(params[:id])

    @calendar = Icalendar::Calendar.new

    event = Icalendar::Event.new
    event.start = @event.start_date.strftime("%Y%m%dT%H%M%S")
    event.end = @event.end_date.strftime("%Y%m%dT%H%M%S")
    event.summary = @event.event
    event.description = @event.description
    #event.location = @event.location

    @calendar.add event 
    @calendar.publish

    send_data(@calendar.to_ical, :type => 'text/calendar', :filename => 'ical.ics')
  end
  
end 