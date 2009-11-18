class Program < ActiveRecord::Base
  
  has_many :calendars
  
  validates_presence_of :name
  
  attr_accessible :name
  
end
