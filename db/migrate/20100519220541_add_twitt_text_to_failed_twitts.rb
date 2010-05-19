class AddTwittTextToFailedTwitts < ActiveRecord::Migration
  def self.up
    add_column :failed_twitts, :twitt_body, :string
  end

  def self.down
    remove_column :failed_twitts, :twitt_body
  end
end
