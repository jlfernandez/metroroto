class Geolocation
  
  def self.geolocate(station="")
    puts "Buscando lat long de la estación #{station}"
    res = Geokit::Geocoders::GoogleGeocoder.geocode("#{station} metro madrid")
    puts res.lat
    puts res.lng  
    return res.lat, res.lng
  end
  
end