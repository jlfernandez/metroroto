# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def station_status(station,line)
    case station.status_by_line(line)
    when 0 then 'red'
    when 1 then 'yellow'
    when 2 then 'green'
    end
  end
  
  def get_direction(incident)
    if incident.direction_id == 0
      "En ambos sentidos"
    elsif incident.direction
      "Sentido #{incident.direction.name}"
    else
      "No sabemos el sentido"
    end
  end
  
  def set_keywords
    base = ["metroroto","Metro de madrid","averias metro","incidencias metro","metro roto"]
    if @line
      base << "Linea #{@line.number}"
      base << "#{@line.stations.first.name}"
      base << "#{@line.stations.last.name}" 
    end
    base.join(", ")
  end
  
  def set_description
    base = "Metroroto, Conoce al momento las incidencias y averias en la red del Metro de Madrid"
    if params[:controller] == 'home'
      base
    elsif params[:controller] == 'lines'
      "Averias e incidencias en la linea #{@line.number}, " + base
    else 
      base
    end
  end
  
  def get_title(sep = '»')
    base = ["Metroroto"]
    if params[:controller] == "home"
      base << "Home » Incidencias en el Metro de Madrid"
    elsif params[:controller] == "lines"
      base << "Incidencias en Linea #{@line.number}"
    end
    base.reverse.join(" #{sep} ")
  end
end
