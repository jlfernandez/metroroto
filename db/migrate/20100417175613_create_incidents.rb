class CreateIncidents < ActiveRecord::Migration
  def self.up
    create_table :incidents do |t|
      t.text :comment
      t.datetime :date
      t.string :user
      t.integer :twitter_id, :unique => true, :limit => 8
      t.integer :line_id
      t.string :station_string
      t.float :lat
      t.float :long
    end
  end

  def self.down
    drop_table :incidents
  end
end
