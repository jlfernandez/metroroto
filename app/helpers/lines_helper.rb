module LinesHelper
  def create_map_line(line)
    js ="var polyline = new GPolyline(["
    line.stations.each do |station|
      js << "new GLatLng(#{station.lat}, #{station.long}),"
    end  
    js << "],'#{line.colour}', 4);"
    js << "map.addOverlay(polyline);"
    
    return js
  end
end
