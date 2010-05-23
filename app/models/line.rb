class Line < ActiveRecord::Base
  has_many :incidents
  has_many :line_stations
  has_many :stations, :through => :line_stations
  has_many :subscriptions, :dependent =>:destroy
  
  LINE_STATUS_LEVELS={"tormentoso" => 0,
                      "nublado" => 1,
                      "nubes" => 2,
                      "solazo" => 3}
  
  def status
    date = self.last_incident_date 

    if date.blank?
      LINE_STATUS_LEVELS["solazo"]
    elsif date > Time.now - 15.minutes
      LINE_STATUS_LEVELS["tormentoso"]
    elsif date > Time.now - 1.hours
      LINE_STATUS_LEVELS["nublado"]
    else
      LINE_STATUS_LEVELS["solazo"]
    end  
      
  end
  
  def last_incident_date
    self.incidents.maximum(:date)
  end
  
end

