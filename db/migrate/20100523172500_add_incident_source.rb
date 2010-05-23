class AddIncidentSource < ActiveRecord::Migration
  def self.up
    add_column :incidents, :source, :integer
    add_column :incidents, :android_id, :long
  end

  def self.down
    remove_column :incidents, :source, :android_id
  end
end
