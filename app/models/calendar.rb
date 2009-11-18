class Calendar < ActiveRecord::Base
    
  belongs_to :program
  
  validates_presence_of :event, :description, :start_date, :end_date
  
  attr_accessible :event, :description, :program_id, :start_date, :end_date

  def self.all_events(page)
    paginate(:page => page, :per_page => 10)
  end
  
  # Find all events from the current day into the future
  def self.current_events(date)
    start_date_gte(date).ascend_by_start_date
  end
  
  # Find all events on the selected day
  def self.day_events(date)
    end_date_gte(date).start_date_lte(date).ascend_by_start_date
  end
  
  # Find all events for the chosen category
  def self.filter_events(prog, month)
    program_id_eq(prog).start_date_gte(month).ascend_by_start_date
  end
end