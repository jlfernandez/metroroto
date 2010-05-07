class Metrotwitt
  require 'twitter'
  def self.last_metrorotos(interval=5.minutes)
    since = Incident.last_twitterid || 0
    twitts = Twitter::Search.new('#metroroto').since(since).fetch().results
    puts "Cargando #{twitts.size} nuevos twitts"
    twitts.each do |twitt|
      self.parse_twitt(twitt)
    end
  end

  def self.parse_twitt(twitt)
      text_arr=twitt["text"].scan(/([^#]*)\s*#(\S*)\s#(\S*)\s#?(\S*)\s*(.*)/).flatten
      unless text_arr.blank?
          incident = Incident.new
          incident.date = twitt["created_at"]
          incident.user = twitt["from_user"]
          incident.twitter_id = twitt["id"]
          text_arr = text_arr.reject{|x| x.blank?}
          #A partir del hashtag metroroto, buscamos los dos siguientes, el orden de los dos es lo mismo
          index = text_arr.index('metroroto')
          if text_arr[index+1].match(/[lL]\d{1,2}/)
              line_number = text_arr[index+1].gsub(/[lL]/,"")
              station_string = text_arr[index+2]
              i = 3
          elsif text_arr[index+2] && text_arr[index+2].match(/[lL]\d{1,2}/)
              line_number = text_arr[index+2].gsub(/[lL]/,"")
              station_string = text_arr[index+1]
              i = 3
          else
            #suponemos que no hay linea y cogemos lo siguiente a metroroto para la estación
            station_string=text_arr[index+1]
            line_number = nil
            i = 2
          end
          i.times do
            text_arr.delete_at(index)
          end
         if line = Line.find_by_number(line_number)
            incident.line_id = line.id
            stations = self.search_stations(station_string,line.stations)
            unless stations.blank?
              incident.station_id = stations.uniq.first.id
            end
          else
            # no nos manda la linea en el twitt
            stations = self.search_stations(station_string,Station)
            unless stations.blank? || stations.size > 1
              incident.station_id = stations.first.id
            end

          end
          if incident.station
            incident.station_string = station_string
            incident.comment = text_arr.join(' ')
            incident.save!
          else
            # aleprosos que no encuentra nada
            fail = FailedTwitt.new(:twitter_id => incident.twitter_id, :date => incident.date, :user => incident.user, :station_string => station_string )
            if incident.line_id
              fail.line_id = incident.line_id
            end
            fail.save!
          end
      end
  end

  def self.search_stations(name,stations)
   if !stations.find_from_twitt(name).blank?
            stations.find_from_twitt(name)
   elsif !stations.find_outspaces(name.downcase).blank?
          stations.find_outspaces(name)
    else
      nil
     end


  end

end

