class LinesController < ApplicationController
  
  def show 
    @line = Line.find(params[:id])
    @incidents = Incident.last_incidents.by_line @line
    respond_to do |wants|
      wants.html
      wants.atom { render :xml => collection_to_feed(@incidents).to_xml }
    end  
  end  
  
end
