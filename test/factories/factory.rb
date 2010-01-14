Factory.define :calendar do |f|
  f.event         'Home Game'
  f.description   'Game against the West Side for state championship'
  f.start_date    Time.now
  f.end_date      Time.now
  f.association   :program_id, :factory => :program
end

Factory.define :program do |f|
  f.name            'Recreational'
  f.created_at      Time.now
  f.updated_at      Time.now
end
