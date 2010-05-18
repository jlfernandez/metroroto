# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def station_status(station)
    case station.status
    when 0 then 'red'
    when 1 then 'yellow'
    when 2 then 'green'
    end
  end
end
