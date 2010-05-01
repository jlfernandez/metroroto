namespace :metroroto do
  desc "Busca los últimos twitts"
  task :search => :environment do
    Metrotwitt.last_metrorotos    
  end
end