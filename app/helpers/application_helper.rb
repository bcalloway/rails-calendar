module ApplicationHelper
  
  #show mini-calendar with events highlighted
  def show_calendar
    if request.request_uri == '/'
      params[:id] = Time.now.strftime('%Y-%m-%d')
    end
    
    @account = Account.find_by_subdomain(current_subdomain)
    @calendars = Calendar.find(:all, :conditions => ['account_id = ?', @account.id])
    
    selection = DateTime.strptime("#{params[:id]}T00:00:00+00:00")
    
    prev_month = selection.advance :months => -1
    next_month = selection.advance :months => 1
    
    calendar( :month => selection.strftime("%m").to_i,
              :year => selection.strftime("%Y").to_i,
              :show_today => true,
              :previous_month_text => (link_to "#{image_tag '/images/left_arrow.gif', :alt => 'Previous Month'}", "/calendar/#{prev_month.strftime('%Y-%m-%d')}"),
              :next_month_text     => (link_to "#{image_tag '/images/right_arrow.gif', :alt => 'Next Month'}", "/calendar/#{next_month.strftime('%Y-%m-%d')}")) do |d|
      cell_text = "#{d.mday}<br />"
      cell_attrs = {:class => 'day'}
      @calendars.each do |e|
        #if (e.start_date.day == d.day) || ( e.start_date <= d && e.end_date >= d )
        if ((e.start_date.year == d.year) && (e.start_date.month == d.month) && (e.start_date.day == d.day)) || ( e.start_date <= d && e.end_date >= d )
          cell_attrs[:class] = 'specialDay'
          cell_text = link_to "#{d.mday}<br />", "/daily_event/#{d}"
        end
      end
      [cell_text, cell_attrs]
   end
  end
end
