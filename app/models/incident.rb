class Incident < ActiveRecord::Base

  belongs_to :station


  before_save :geolocate
  
  after_save :retwitt
  
  validates_presence_of :station
  
  INCIDENT_LEVELS={"inmediato" => 0,
                   "hace_un_rato" => 1,
                   "hace_mucho" => 2}
  
  def self.last_incidents
    Incident.find(:all, :conditions => "date > '#{(Time.now - 30.days).to_s(:db)}'", :order => "date DESC")
  end

  def self.last_twitterid
    Incident.maximum(:twitter_id)
  end

  def options_for_feed
    {
      :id => id,
      :title => "Incidencia en Línea #{self.line.number} en la estación de #{self.station.name}",
      :content => comment,
      :date => date
    }
  end

  def line
    station.line
  end
  
  def status
    if date > Time.now - 15.minutes
      INCIDENT_LEVELS["inmediato"]
    elsif date > Time.now - 1.hour
      INCIDENT_LEVELS["hace_un_rato"]
    else
      INCIDENT_LEVELS["hace_mucho"]
    end
  end
  
  def self.group_by_station_name(incidents)
    incidents.inject({}) do |hash, incident|
      hash[incident.station.name] ||= []
      hash[incident.station.name] << incident
      hash[incident.station.name].sort{|a,b| -(a.date <=> b.date)}
      hash
    end
  end
  
  private

  def geolocate
    self.lat, self.long = if self.station && self.station.lat && self.station.long
        [self.station.lat,self.station.long]
     else
       #Geolocation.geolocate(self.station.name)
     end
  end
  
  def retwitt
    Metrotwitt.send_later(:retwitt,self)
  end

end

