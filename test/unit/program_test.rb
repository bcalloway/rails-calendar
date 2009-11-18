require 'test_helper'

class ProgramTest < ActiveSupport::TestCase

  should_have_many :calendars
  should_validate_presence_of :name
  
  should_allow_mass_assignment_of :name
end