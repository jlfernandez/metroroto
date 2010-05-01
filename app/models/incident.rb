class Incident < ActiveRecord::Base
  
  belongs_to :line
  
  validates_uniqueness_of :twitter_id
  
  def self.last_incidents
    Incident.find(:all, :conditions => "date > '#{(Time.now - 30.days).to_s(:db)}'")
  end
  
  def self.last_twitterid
    Incident.maximum(:twitter_id)
  end
  
end
