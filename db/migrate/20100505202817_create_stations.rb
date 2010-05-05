class CreateStations < ActiveRecord::Migration
  def self.up
    create_table :stations do |t|
      t.string :name
      t.string :nicename
      t.integer :line_id
      t.float :lat
      t.float :long
      t.timestamps
    end
  end

  def self.down
    drop_table :stations
  end
end

