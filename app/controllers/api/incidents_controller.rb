class Api::IncidentsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  
  def create
    begin 
      send("create_#{params[:version]}")
    rescue StandardError => e
      logger.error("ERROR EN LA API")
      logger.error(e.backtrace.join("\n"))
      render :text => "Error: #{e.to_s}", :status => 500, :layout => false
    end
  end

  def create_v1
    # En la API los parámetros son:
    # "line_id"=>"3", "direction_nicename"=>"villaverde-alto", "station_nicename"=>"san-cristobal"}
    p = params[:incident]
    p[:station] = Station.by_line(p[:line_id]).scoped_by_nicename(p.delete(:station_nicename)).first
    p[:direction] = Station.by_line(p[:line_id]).scoped_by_nicename(p.delete(:direction_nicename)).first

    incident = Incident.new(p.merge(:source => Incident::SOURCE[:android]))
    
    incident.date = Time.now
    incident.save!
    render :text => "¡¡Incidencia añadida!!", :status => 200, :layout => false
  end
  
end
