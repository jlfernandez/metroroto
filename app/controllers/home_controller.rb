class HomeController < ApplicationController
  
  def index
    @incidents = Incident.last_incidents
  end
  
end