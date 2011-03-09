class Api::V1::IncidentsController < Api::BaseController
  layout false
  def create
    # En la API los parámetros son:
    # {"action"=>"create",
    #  "controller"=>"api/v1/incidents",
    #  "incident"=>{"comment"=>"TESTING ANDROID APP: Wadus",
    #               "line_id"=>"2", "station_nicename"=>"manuel-becerra",
    #                "direction_nicename"=>"cuatro-caminos"}}
    p = params[:incident]
    p[:station] = Station.by_line(p[:line_id]).scoped_by_nicename(p.delete(:station_nicename)).first
    p[:direction] = Station.by_line(p[:line_id]).scoped_by_nicename(p.delete(:direction_nicename)).first

    incident = Incident.new(p.merge(:source => Incident::SOURCE[:android]))
    incident.comment = incident.comment.gsub("TESTING ANDROID APP:", "")
    
    incident.date = Time.now
    incident.save!
    render :text => "¡¡Incidencia añadida!!", :status => 200, :layout => false
  end

  def last
    @incidents = Incident.last_incidents.all(:limit => 20)
    respond_to do |format|
      format.xml
      format.js do
        render :text => @incidents.to_json
      end
    end
  end
end
