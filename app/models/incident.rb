class Incident < ActiveRecord::Base

  belongs_to :station


  before_save :geolocate
  validates_presence_of :station
  def self.last_incidents
    Incident.find(:all, :conditions => "date > '#{(Time.now - 30.days).to_s(:db)}'", :order => "date DESC")
  end

  def self.last_twitterid
    Incident.maximum(:twitter_id)
  end

  def options_for_feed
    {
      :id => id,
      :title => "Incidencia en Línea #{self.line_id} en la estación de #{self.station}",
      :content => comment,
      :date => date
    }
  end

  def line
    station.line
  end

  private

  def geolocate
    self.lat, self.long = if self.station && self.station.lat && self.station.long
        [self.station.lat,self.station.long]
     else
       #Geolocation.geolocate(self.station.name)
     end
  end

end

