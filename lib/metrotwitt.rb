class Metrotwitt
  require 'twitter'
  def self.last_metrorotos(interval=5.minutes)
    since = [Incident.last_twitterid || 0,FailedTwitt.last_twitterid || 0].max || 0
    twitts = Twitter::Search.new('#metroroto').since(since).fetch().results
    twitts.reverse! #Esto se hace para que guarde primero los más antiguos, y se retwitteen en orden.
    puts "Cargando #{twitts.size} nuevos twitts"
    twitts.each do |twitt|      
      self.parse_twitt(twitt) unless twitt.from_user == "metroroto"
    end
  end

  def self.parse_twitt(twitt)
    normalized_text = twitt.text.strip.gsub("\n","")
    text_arr=normalized_text.scan(/([^#]*)\s*#(\S*)\s#(\S*)\s?#?(\S*)\s*(.*)/).flatten
    text = normalized_text
    incident = Incident.new(:source => Incident::SOURCE[:twitter])
    #Transformamos la fecha del twitt, que viene en utc, a nuestra hora local
    incident.date = twitt["created_at"].to_time.getlocal
    incident.user = twitt["from_user"]
    incident.twitter_id = twitt["id"]
    unless text_arr.blank?

      # si entramos aqui, hemos encontrado una estructura standar del twitt
      # #metroroto #l1 #estrecho wadu wadus o wadus wadus #metroroto #l1 #estrecho


      text_arr = text_arr.reject{|x| x.blank?}
      #A partir del hashtag metroroto, buscamos los dos siguientes, el orden de los dos es lo mismo          

      if index = text_arr.index('metroroto')

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
          # ultimo intento para la linea
          if text.match(/[lL]\d{1,2}/)
            line_number = text.match(/[lL]\d{1,2}/).to_s.gsub(/[lL]/,"")
          else
            line_number = nil
          end            
          i = 2
        end
        i.times do
          text_arr.delete_at(index)
        end
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
          # asignamos la estacion si solo tiene una linea (sino es ambigua)
          incident.line_id = stations.first.lines.first.id if stations.first.lines.size == 1
        end

      end          
      if incident.station.blank?
        # Tratamos de encontrar la estacion a la fuerza bruta
        Station.all.each do |station|
          next unless (text.match(station.name) || text.parameterize.match(station.nicename))
          station_string = if text.match(station.name)
            text.match(station.name).to_s
          else
            text.parameterize.match(station.nicename).to_s
          end
          if line
            stations = self.search_stations(station_string,line.stations)
            unless stations.blank?
              incident.station_id = stations.uniq.first.id
            end
          else
            incident.station_id = station.id 
          end
          break
        end              
      end
    else
      #no cuadra la estructura estandar del twitt, buscamos a la fuerza bruta!!
      if text.match(/[lL]\d{1,2}/)
        line_number = text.match(/[lL]\d{1,2}/).to_s.gsub(/[lL]/,"")
        if line = Line.find_by_number(line_number)
          incident.line_id = line.id
        end
      end            
      Station.all.each do |station|
        next unless (text.match(station.name) || text.parameterize.match(station.nicename))
        station_string = if text.match(station.name)
          text.match(station.name).to_s
        else
          text.parameterize.match(station.nicename).to_s
        end
        if line
          stations = self.search_stations(station_string,line.stations)
          unless stations.blank?
            incident.station_id = stations.uniq.first.id
          end
        else
          incident.station_id = station.id 
        end
        break
      end              

    end


    if incident.station && incident.line_id
      incident.station_string = station_string
      incident.comment = text_arr.blank? ? text.gsub(/#(.*)/,'') : text_arr.join(' ')
      incident.save!
    else            
      # aleprosos que no encuentra nada
      station_string ||= ""
      fail = FailedTwitt.new(:twitter_id => incident.twitter_id, :date => incident.date, :user => incident.user, :station_string => station_string, :twitt_body => text )
      if incident.line_id
        fail.line_id = incident.line_id
      end
      fail.save!
    end

  end

  def self.search_stations(name,stations)
    begin
    if !stations.find_from_twitt(name).blank?
      stations.find_from_twitt(name)
    elsif !stations.find_outspaces(name.downcase).blank?
      stations.find_outspaces(name)
    else
      nil
    end
    rescue
    end

  end

  def self.retwitt(incident)
    puts "Retwitt..."
    unless Rails.env=="test"
      client = self.connect_twitter
      user = incident.user ? "by @#{incident.user}" : ""
      with_metroroto = incident.user ? "" : "#metroroto"
      begin
        client.update("#{with_metroroto} ##{incident.station.nicename.gsub("-","")} 
        #l#{incident.line.number} #{incident.comment} #{user}")
      rescue
        puts "No se ha podido retwittear la incidencia #{incident.id} por alguna razón (twitt duplicado probablemente)"
      end  
    end
  end

  private

  def self.connect_twitter
    oauth = Twitter::OAuth.new(OAUTH_CONSUMER_TOKEN, OAUTH_CONSUMER_SECRET_TOKEN)
    oauth.authorize_from_access(OAUTH_ACCESS_TOKEN, OAUTH_ACCESS_SECRET_TOKEN)
    return Twitter::Base.new(oauth)
  end

end

