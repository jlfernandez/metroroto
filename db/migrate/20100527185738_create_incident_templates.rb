class CreateIncidentTemplates < ActiveRecord::Migration
  def self.up
    create_table :incident_templates do |t|
      t.string :comment
    end
  end

  def self.down
    drop_table :incident_templates
  end
end
