class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string :email, :null => :false
      t.references :line, :null => :false
      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
