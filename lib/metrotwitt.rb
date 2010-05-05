class Metrotwitt
  require 'twitter'
require 'ruby-debug'
  def self.last_metrorotos(interval=5.minutes)
    since = Incident.last_twitterid || 0
    twitts = Twitter::Search.new('#metroroto').since(since).fetch().results
    self.process_twitts twitts
  end

  def self.process_twitts(twitts)
    puts "Cargando #{twitts.size} nuevos twitts"
    twitts.each do |twitt|
      text_arr=twitt["text"].scan(/(.*)#(.*)#(.*)#(.*)/)[0]
      unless text_arr.blank?
          incident = Incident.new
          incident.date = twitt["created_at"]
          incident.user = twitt["from_user"]
          incident.twitter_id = twitt["id"]
          station_string = text_arr[3]
          line_number = text_arr[2].gsub("l","").to_i
          if line = Line.find_by_number(line_number)
            incident.line_id = line.id
            station = line.stations.find_exact_from_twitt(station_string)
            if station.blank?
              station = line.stations.find_from_twitt(station_string)
            end
            unless station.blank?
              incident.station_id = station.first.id
            else
             #no hemos macheado ni exacto ni aproximado con ninguna extación, podemos consultar a google :)
            end
          else
            # no nos manda la linea en el twitt
            station = Station.find_exact_from_twitt(station_string)
            if station.blank?
              station = Stations.find_from_twitt(station_string)
            end
            unless station.blank? || station.size > 1
              incident.station_id = station.first.id
            else
              # no tenemos la linea en el twitt, y por la estación tenemos mas de una posibilidad: Es ambiguo, lo descartamos
            end

          end
          incident.comment = text_arr[0]
          incident.save!
      end
    end
  end

end

