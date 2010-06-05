class Api::V1::IncidentsController < Api::BaseController

  def create
    # En la API los parámetros son:
    # "line_id"=>"3", "direction_nicename"=>"villaverde-alto", "station_nicename"=>"san-cristobal"}
    p = params[:incident]
    p[:station] = Station.by_line(p[:line_id]).scoped_by_nicename(p.delete(:station_nicename)).first
    p[:direction] = Station.by_line(p[:line_id]).scoped_by_nicename(p.delete(:direction_nicename)).first

    incident = Incident.new(p.merge(:source => Incident::SOURCE[:android]))
    incident.comment = incident.comment.gsub("TESTING ANDROID APP:", "")
    
    incident.date = Time.now
    incident.save!
    render :text => "¡¡Incidencia añadida!!", :status => 200, :layout => false
  end
  
end
