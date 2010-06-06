module IncidentHelper
  def incident_markers(incidents)
    js_code = ""
    
    incidents.each do |incident|
     div_info ="'<div class=\"map_pop\"><a href=\"/lines/#{incident.line.number}\" class=\"line_number line_#{incident.line.number}\">#{incident.line.number}</a><ul><li><span class=\"station\">#{incident.station.name}</span></p><p class=\"date\">#{l(incident.date, :format => "long")}</p><p class=\"comment\">Incidencia: #{escape_javascript(h(incident.comment))}</p></li></ul></div>'"
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
    incidents_by_station = Incident.group_by_station_and_line(incidents)
    
    js_code = ""
    
    incidents_by_station.each do |station, incidents_by_line|
      div_info = "'<div class=\"map_pop\">"
      div_info << "<span class=\"station\">#{station.name}</span>"
      div_info << "<ul>"
      
      incidents_by_line.each do |line, incidents|
        unless incidents.empty?
          div_info << escape_javascript(render(:partial => "incidents/station_marker_line_incidents", :locals => {:line => line, :incidents => incidents}))
        end
      end
      div_info << "</ul>"
      div_info << "</div>'"
      
      append_incident_marker_js(js_code, incidents_by_line.values.flatten.sort_by(&:date).first, div_info)
    end unless incidents_by_station.blank?
    
    js_code
  end
end

