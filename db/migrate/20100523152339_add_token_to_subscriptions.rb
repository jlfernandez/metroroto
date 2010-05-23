class AddTokenToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :verification_token, :string
    
  end

  def self.down
    remove_column :subscriptions, :verification_token
  end
end
