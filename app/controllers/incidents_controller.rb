class IncidentsController < ApplicationController

  def last
    render :text => Incident.last_incidents.to_json
  end

  def create
    incident = Incident.new(params[:incident])
    incident.date = Time.now
    incident.save!
    redirect_to root_path
  end

end

