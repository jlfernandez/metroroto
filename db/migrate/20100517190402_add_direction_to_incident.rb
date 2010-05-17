class AddDirectionToIncident < ActiveRecord::Migration
  def self.up
    add_column :incidents, :direction_id, :integer
  end

  def self.down
    remove_column :incident, :direction_id
  end
end
