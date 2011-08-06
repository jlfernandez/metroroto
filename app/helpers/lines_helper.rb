module LinesHelper
  def create_map_line(line)
    js ="var polyline = new GPolyline(["
    line.stations.each do |station|
      js << "new GLatLng(#{station.lat}, #{station.long}),"
    end  
    js << "],'#{line.colour}', 4,1);"
    js << "map.addOverlay(polyline);"
    
    return js
  end
  
  def line_status(line)
    case line.status
    when Line::LINE_STATUS_LEVELS["tormentoso"]
      content_tag(:span, 'Línea con incidencias largas', :class => "breakdown_2")
    when Line::LINE_STATUS_LEVELS["nublado"]
      content_tag(:span, 'Línea con incidencias cortas', :class => "breakdown_1")
    when Line::LINE_STATUS_LEVELS["solazo"]
      content_tag(:span, 'Línea abierta', :class => "ok")
    end
  end
  
end
