class CreateLines < ActiveRecord::Migration
  def self.up
    create_table :lines do |t|
      t.string :number
      t.string :name
    end
  end

  def self.down
    drop_table :lines
  end
end
