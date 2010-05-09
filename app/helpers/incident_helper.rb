module IncidentHelper
  def incident_markers(incidents)
    js_code = ""
    div_info = ""
    js_code << "var metroIcon = new GIcon(G_DEFAULT_ICON);"
    incidents.each do |incident|
     div_info ="'<div class=\"map_pop\"><p><span class=\"line_number line_#{incident.line.number}\">#{incident.line.number}</span><span class=\"station\">#{incident.station.name}</span></p><p class=\"date\">#{l(incident.date, :format => "long")}</p><p class=\"comment\">Incidencia: #{incident.comment}</p></div>'"
     js_code << "metroIcon.image = 'images/#{incident_icon incident}';"  
     js_code << "map.addOverlay(addInfoWindowToMarker(new GMarker("
     js_code << "new GLatLng(#{incident.lat},#{incident.long}),"
     js_code << "{title : 'Incidencia en línea #{incident.line_id}', icon:metroIcon}),"
     js_code << div_info
     js_code << ",{}));"
    end unless incidents.blank?
    js_code
  end

  def incident_icon(incident)
    case incident.status
    when Incident::INCIDENT_LEVELS["inmediato"]
      "inmediato.png"
    when Incident::INCIDENT_LEVELS["hace_un_rato"]
      "hace_un_rato.png"
    when Incident::INCIDENT_LEVELS["hace_mucho"]
      "hace_mucho.png"
    end
  end

end

