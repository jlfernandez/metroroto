class Incident < ActiveRecord::Base
  
  belongs_to :line
  
  before_save :geolocate
  
  def self.last_incidents
    Incident.find(:all, :conditions => "date > '#{(Time.now - 30.days).to_s(:db)}'", :order => "date DESC")
  end
  
  def self.last_twitterid
    Incident.maximum(:twitter_id)
  end
  
  private
  
  def geolocate
    self.lat, self.long = Geolocation.geolocate(self.station)
  end
  
end
