module LinesHelper
  def create_map_line(line)
    js ="var polyline = new GPolyline(["
    line.stations.each do |station|
      js << "new GLatLng(#{station.lat}, #{station.long}),"
    end  
    js << "],'#{line.colour}', 8);"
    js << "map.addOverlay(polyline);"
    
    return js
  end
  
  def line_status(line)
    case line.status
    when Line::LINE_STATUS_LEVELS["tormentoso"]
      "<span class=\"breakdown_3\">Línea cerrada</span>"
    when Line::LINE_STATUS_LEVELS["nublado"]
      "<span class=\"breakdown_2\">Línea con incidencias largas </span>"
    when Line::LINE_STATUS_LEVELS["nubes"]
      "<span class=\"breakdown_1\">Línea con incidencias cortas</span>"
    when Line::LINE_STATUS_LEVELS["solazo"]
      "<span class=\"ok\">Línea abierta</span>"
    end    
  end
  
end
