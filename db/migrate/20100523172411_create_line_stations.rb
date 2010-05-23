class CreateLineStations < ActiveRecord::Migration
  def self.up
    create_table :line_stations do |t|
      t.integer :line_id
      t.integer :station_id

      t.timestamps
    end
    
    remove_column :stations, :line_id
  end

  def self.down
    drop_table :line_stations
    add_column :stations, :line_id, :integer
  end
end
