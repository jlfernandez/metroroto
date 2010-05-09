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
  
  def line_status_image(line)
    case line.status
    when Line::LINE_STATUS_LEVELS["tormentoso"]
      "img_tormenta.gif"
    when Line::LINE_STATUS_LEVELS["nublado"]
      "img_nublado.gif"
    when Line::LINE_STATUS_LEVELS["nubes"]
      "img_nubes.gif"
    when Line::LINE_STATUS_LEVELS["solazo"]
      "img_solazo.gif"  
    end    
  end
  
end
