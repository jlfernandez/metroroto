class CreateFailedTwitts < ActiveRecord::Migration
  def self.up
    create_table :failed_twitts do |t|
      t.string :station_string
      t.datetime :date
      t.string :user
      t.integer :twitter_id, :unique => true, :limit => 8
      t.integer :line_id

      t.timestamps
    end
  end

  def self.down
    drop_table :failed_twitts
  end
end

