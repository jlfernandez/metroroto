class HomeController < ApplicationController
  
  def index
    @incidents = Incident.last_incidents
    respond_to do |wants|
      wants.html
      wants.atom { render :xml => collection_to_feed(@incidents).to_xml}
    end  
  end
  
  def last
    index
  end

  
end
