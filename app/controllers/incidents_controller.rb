class IncidentsController < ApplicationController

  def last
    render :text => Incident.last_incidents.to_json 
  end  
  
end
