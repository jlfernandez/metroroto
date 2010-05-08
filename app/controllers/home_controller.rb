class HomeController < ApplicationController
  
  def index
    @incidents = Incident.last_incidents
    respond_to do |wants|
      wants.html
      wants.atom { render :xml => collection_to_feed(@incidents).to_xml}
    end  
  end
  
  def new_incident
    incident = Incident.new(params[:incident])
    incident.date = Time.now
    incident.save!
    @incidents = Incident.last_incidents
    render :partial => "last_incidents"
  end
  
end