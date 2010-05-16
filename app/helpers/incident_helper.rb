module IncidentHelper
  def incident_markers(incidents)
    js_code = ""
    
    incidents.each do |incident|
     div_info ="'<div class=\"map_pop\"><p><span class=\"line_number line_#{incident.line.number}\">#{incident.line.number}</span><span class=\"station\">#{incident.station.name}</span></p><p class=\"date\">#{l(incident.date, :format => "long")}</p><p class=\"comment\">Incidencia: #{incident.comment}</p></div>'"
     append_incident_marker_js(js_code, incident, div_info)
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
  
  def append_incident_marker_js(buffer, incident, content)
    icon_declaration = "var metroIcon = new GIcon(G_DEFAULT_ICON);"
    buffer << icon_declaration unless buffer.include?(icon_declaration)
    buffer << "metroIcon.image = '/images/#{incident_icon incident}';"  
    buffer << "map.addOverlay(addInfoWindowToMarker(new GMarker("
    buffer << "new GLatLng(#{incident.lat},#{incident.long}),"
    buffer << "{title : 'Incidencia en #{incident.station.name}', icon:metroIcon}),"
    buffer << content
    buffer << ",{}));"
  end
  
  def incident_markers_grouped_by_station(incidents)
    incidents_by_station = Incident.group_by_station_name(incidents)
    
    js_code = ""
    
    incidents_by_station.each do |station_name, station_incidents|
      div_info = "'<div class=\"map_pop\">"
      div_info << "<p><span class=\"station\">#{station_name}</span></p>"
      
      station_incidents.each do |incident|
        div_info << "<p><span class=\"line_number line_#{incident.line.number}\">#{incident.line.number}</span></p>"
        div_info << "<p class=\"date\">#{l(incident.date, :format => "long")}</p>"
        div_info << "<p class=\"comment\">Incidencia: #{incident.comment}</p>"
      end
      
      div_info << "</div>'"
      
      append_incident_marker_js(js_code, station_incidents.first, div_info)
    end unless incidents_by_station.blank?
    
    js_code
  end
end

