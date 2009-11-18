require 'test_helper'

class CalendarTest < ActiveSupport::TestCase

  should_belong_to :program
  should_validate_presence_of :description, :event, :start_date, :end_date
  
  should_allow_mass_assignment_of :event, :description, :program_id, :start_date, :end_date

end
