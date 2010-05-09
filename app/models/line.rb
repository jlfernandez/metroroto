class Line < ActiveRecord::Base
  has_many :incidents, :through => :stations
  has_many :stations,:dependent =>:destroy
  
  LINE_STATUS_LEVELS={"tormentoso" => 0,
                      "nublado" => 1,
                      "nubes" => 2,
                      "solazo" => 3}
  
  def status
    date = self.last_incident_date 

    if date.blank?
      LINE_STATUS_LEVELS["solazo"]
    elsif date > Time.now - 30.minutes
      LINE_STATUS_LEVELS["tormentoso"]
    elsif date > Time.now - 2.hours
      LINE_STATUS_LEVELS["nublado"]
    elsif date > Time.now - 5.hours
      LINE_STATUS_LEVELS["nubes"]
    else
      LINE_STATUS_LEVELS["solazo"]
    end  
      
  end
  
  def last_incident_date
    self.incidents.maximum(:date)
  end
  
end

