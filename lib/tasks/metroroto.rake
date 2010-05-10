namespace :metroroto do
  desc "Busca los últimos twitts"
  task :search => :environment do
    Metrotwitt.last_metrorotos
  end

  desc "Carga las estaciones de metro y su localización"

  task :load_stations => :environment do
    Metroparser.load_stations
    Station.update_wrong_stations
  end
end

