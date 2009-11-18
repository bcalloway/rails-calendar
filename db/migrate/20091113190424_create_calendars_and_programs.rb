class CreateCalendarsAndPrograms < ActiveRecord::Migration
  def self.up
    create_table :calendars do |t|
      t.string :event
      t.text :description
      t.integer :program_id
      t.datetime :start_date
      t.datetime :end_date
      t.timestamps
    end

    create_table :programs do |t|
      t.string :name
      t.timestamps
    end

  end

  def self.down
    drop_table :calendars
    drop_table :programs
  end
end