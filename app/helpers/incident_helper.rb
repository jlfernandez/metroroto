module IncidentHelper
  def incident_markers(incidents)
    js_code = ""
    div_info = ""
    incidents.each do |incident|
     div_info ="'<div class=\"map_pop\"><p class=\"line_number line_#{incident.line_id}\">#{incident.line_id}</p><p class=\"station\">#{incident.station.name}</p><p>Incidencia: #{incident.comment}</p></div>'"
     js_code << "map.addOverlay(addInfoWindowToMarker(new GMarker("
     js_code << "new GLatLng(#{incident.lat},#{incident.long}),"
     js_code << "{title : 'Incidencia en línea #{incident.line_id}'}),"
     js_code << div_info
     js_code << ",{}));"
    end unless incidents.blank?
    js_code
  end


end

