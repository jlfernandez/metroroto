class Metrotwitt
  require 'Twitter'
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
          incident.line_id = text_arr[2].gsub("l","").to_i 
          incident.station = text_arr[3] 
          incident.comment = text_arr[0] 
          incident.lat, incident.long = Geolocation.geolocate(text_arr[3])
          incident.save!      
      end  
    end
  end
  
end