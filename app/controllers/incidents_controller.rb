class IncidentsController < ApplicationController
  
  def create
    incident = Incident.new(params[:incident].merge(
        :source => Incident::SOURCE[:web]))
    if incident.source == 2
      incident.comment.gsub("TESTING ANDROID APP:", "")
    end
    incident.date = Time.now
    incident.save!
    @incidents = Incident.last_incidents
    render :partial => "last_incidents"
  end




end

