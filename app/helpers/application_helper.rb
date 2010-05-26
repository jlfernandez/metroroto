# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def station_status(station)
    case station.status
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
end
