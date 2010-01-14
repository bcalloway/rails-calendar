module CalendarsHelper
  
  #show mini-calendar with events highlighted
  def mini_calendar
    if request.request_uri == '/'
      params[:id] = Time.now.strftime('%Y-%m-%d')
    end
    
    @calendars = Calendar.all
    
    selection = DateTime.strptime("#{params[:id]}T00:00:00+00:00")
    
    prev_month = selection.advance :months => -1
    next_month = selection.advance :months => 1
    
    calendar( :month => selection.strftime("%m").to_i,
              :year => selection.strftime("%Y").to_i,
              :show_today => true,
              :previous_month_text => (link_to "#{image_tag '/images/left_arrow.gif', :alt => 'Previous Month'}", "/calendar/#{prev_month.strftime('%Y-%m-%d')}"),
              :next_month_text     => (link_to "#{image_tag '/images/right_arrow.gif', :alt => 'Next Month', :align => 'right'}", "/calendar/#{next_month.strftime('%Y-%m-%d')}")) do |d|
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
  
  # Show full calendar on calendar & events page with events highlighted
  def main_calendar
    if params[:id]
      @time_now = "#{params[:id]}"
    else
      @time_now = "#{Time.now.strftime('%Y-%m-%d')}"
    end
    
    selection = DateTime.strptime("#{@time_now}T00:00:00+00:00") 

    prev_month = selection.advance :months => -1
    next_month = selection.advance :months => 1

    calendar( :month => selection.strftime("%m").to_i,
              #:month => params[:mo].to_i,
              :year => selection.strftime("%Y").to_i,
              :show_today => true,
              :previous_month_text => (link_to "#{image_tag '/images/left_arrow.gif', :alt => 'Previous Month'}", "#{prev_month.strftime('%Y-%m-%d')}"),
              :next_month_text     => (link_to "#{image_tag '/images/right_arrow.gif', :alt => 'Next Month'}", "#{next_month.strftime('%Y-%m-%d')}")) do |d|

     cell_text = "<p class=\"num\">#{d.mday}</p><br />"
     cell_attrs = {:class => 'day'}
     @events.each do |e|
       if ((e.start_date.year == d.year) && (e.start_date.month == d.month) && (e.start_date.day == d.day)) || ( e.start_date <= d && e.end_date >= d )
        cell_attrs[:class] = 'specialDay' 
        cell_text += link_to "#{e.event}", "/calendars/show/#{e.id}", :rel => 'facebox', :class => "text"
        cell_text += "<br />"
       end
     end
     [cell_text, cell_attrs]
   end
  end

  # titleify strips out the ()'s, lowercases all word characters, and then formats the title in proper english via the titleize gem
  def titleify(urlstring)
    urlstring = urlstring.downcase.strip
    urlstring = urlstring.gsub(/\([A-Za-z0-9\.\s]*\)/, "")
    urlstring = urlstring.gsub(/\s+/, " ")
    urlstring = urlstring.titleize

    return urlstring
  end
end