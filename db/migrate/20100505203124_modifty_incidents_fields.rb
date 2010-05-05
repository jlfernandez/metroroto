class ModiftyIncidentsFields < ActiveRecord::Migration
  def self.up
    add_column :incidents, :station_id, :integer
  end

  def self.down
    remove_column :incidents, :station_id
  end
end

