require 'nokogiri'
require 'open-uri'
module Metroparser
DOCS = { "1" => "http://www.metromadrid.es/es/viaja_en_metro/red_de_metro/lineas_y_horarios/linea01.html",
  "2" => "http://www.metromadrid.es/es/viaja_en_metro/red_de_metro/lineas_y_horarios/linea02.html",
  "3" => "http://www.metromadrid.es/es/viaja_en_metro/red_de_metro/lineas_y_horarios/linea03.html",
  "4" => "http://www.metromadrid.es/es/viaja_en_metro/red_de_metro/lineas_y_horarios/linea04.html",
  "5" => "http://www.metromadrid.es/es/viaja_en_metro/red_de_metro/lineas_y_horarios/linea05.html",
  "6" => "http://www.metromadrid.es/es/viaja_en_metro/red_de_metro/lineas_y_horarios/linea06.html",
  "7" => "http://www.metromadrid.es/es/viaja_en_metro/red_de_metro/lineas_y_horarios/linea07.html",
  "8" => "http://www.metromadrid.es/es/viaja_en_metro/red_de_metro/lineas_y_horarios/linea08.html",
  "9" => "http://www.metromadrid.es/es/viaja_en_metro/red_de_metro/lineas_y_horarios/linea09.html",
  "10" => "http://www.metromadrid.es/es/viaja_en_metro/red_de_metro/lineas_y_horarios/linea10.html",
  "11" => "http://www.metromadrid.es/es/viaja_en_metro/red_de_metro/lineas_y_horarios/linea11.html",
  "12" => "http://www.metromadrid.es/es/viaja_en_metro/red_de_metro/lineas_y_horarios/linea12.html",
  "R" => "http://www.metromadrid.es/es/viaja_en_metro/red_de_metro/lineas_y_horarios/lineaR.html"

}

  def self.load_stations
    Metroparser::DOCS.each_pair do |key,value|
      self.parse_document(value,key)
    end
  end
  def self.parse_document(path,line)
    begin
      if doc = Nokogiri::HTML(open(path))
        line = Line.find_by_number(line)
        doc.css('div.lin_est table tr').each do |tr|
          column = tr.css('td')[1]
          unless column.blank?
            name = column.css('a').text
            lat,long = Geolocation.geolocate(name)
            Station.find_or_create_by_name_and_line_id(:name => name, :line_id => line.id, :lat => lat , :long => long)
          end
        end
      end
    rescue  OpenURI::HTTPError
        puts "errorrrrrr 5000"
    end
  end

end

