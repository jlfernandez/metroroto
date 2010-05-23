require 'test_helper'

class MetrotwittTest < ActiveSupport::TestCase
  # Replace this with your real tests.

  fixtures :stations, :lines

  test "debe reconocer el patron: Nuevo twitt de prueba #metroroto #l1 #estrecho" do
    Metrotwitt.parse_twitt(create_twitt("Nuevo twitt de prueba #metroroto #l1 #estrecho"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,1
    assert_equal Incident.last.station.nicename, 'estrecho'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba "
  end

  test "debe reconocer el patron: #metroroto #l1 #estrecho Nuevo twitt de prueba " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l1 #cuatrocaminos Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,1
    assert_equal Incident.last.station.nicename, 'cuatro-caminos'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end
  
  test "debe reconocer las lineas con l y L" do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #L5 #puerta Metro roto en puerta de toledo"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,5
    assert_equal Incident.last.station.nicename, 'puerta-de-toledo'
    assert_equal Incident.last.comment, "Metro roto en puerta de toledo"
  end


  test "debe reconocer el patron: #metroroto #l6 #guzmanelbueno Nuevo twitt de prueba " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l6 #guzmanelbueno Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,6
    assert_equal Incident.last.station.nicename, 'guzman-el-bueno'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end

  test "debe reconocer el patron: Test 1 " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l6 #manuel_becerra Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,6
    assert_equal Incident.last.station.nicename, 'manuel-becerra'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end


  test "debe reconocer el patron: Test 2 " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l6 #manuel-becerra Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,6
    assert_equal Incident.last.station.nicename, 'manuel-becerra'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end

  test "debe reconocer el patron: Test 3 " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l6 #manuelbecerra Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,6
    assert_equal Incident.last.station.nicename, 'manuel-becerra'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end

  test "debe reconocer el patron: Test 4 " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l6 #arganzuela Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,6
    assert_equal Incident.last.station.nicename, 'arganzuela-planetario'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end

  test "debe reconocer el patron: Test 5 " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l6 #odonnell Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,6
    assert_equal Incident.last.station.nicename, 'o-donnell'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end

  test "debe reconocer el patron: Test 6 " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l6 #O-donnell Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,6
    assert_equal Incident.last.station.nicename, 'o-donnell'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end

    test "debe reconocer el patron: Test 7 " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l10 #infantasofia Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,10
    assert_equal Incident.last.station.nicename, 'hospital-infanta-sofia'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end

      test "debe reconocer el patron: Test 8 " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l10 #infanta-sofia Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,10
    assert_equal Incident.last.station.nicename, 'hospital-infanta-sofia'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end

      test "debe reconocer el patron: Test 9 " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l10 #hospital_infanta Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,10
    assert_equal Incident.last.station.nicename, 'hospital-infanta-sofia'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end

  test "debe reconocer el patron: Test 10 " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l10 #santiagobernabeu Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,10
    assert_equal Incident.last.station.nicename, 'santiago-bernabeu'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end

  test "debe reconocer el patron: Test 11 " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l10 #rondadelacomunicacion Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,10
    assert_equal Incident.last.station.nicename, 'ronda-de-la-comunicacion'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end

    test "debe reconocer el patron: Test 12 " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l4 #alfonso Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,4
    assert_equal Incident.last.station.nicename, 'alfonso-xiii'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end


  test "debe reconocer el patron: Test 13 " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l4 #alfonsoxiii Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,4
    assert_equal Incident.last.station.nicename, 'alfonso-xiii'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end

  test "debe reconocer el patron: con linea y estacion a medias funciona " do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l4 #alonso Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,4
    assert_equal Incident.last.station.nicename, 'alonso-martinez'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end
    test "debe reconocer el patron: con linea y estacion a medias funciona v2" do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #l4 #parque Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,4
    assert_equal Incident.last.station.nicename, 'parque-de-santa-maria'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end

    test "debe reconocer el patron: sin linea y comment detras" do
    Metrotwitt.parse_twitt(create_twitt("#metroroto #delicias Nuevo twitt de prueba"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,3
    assert_equal Incident.last.station.nicename, 'delicias'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba"
  end

  test "current debe reconocer el patron: sin linea, comment delante" do
    Metrotwitt.parse_twitt(create_twitt("Nuevo twitt de prueba #metroroto #panbendito "))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,11
    assert_equal Incident.last.station.nicename, 'pan-bendito'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba "
  end

  test "no debe reconocer el patron: sin linea,y con estación ambigua" do
    Metrotwitt.parse_twitt(create_twitt("Nuevo twitt de prueba #metroroto #sol "))
    assert_equal 0,Incident.all.size
    assert_equal 1, FailedTwitt.all.size
  end

  test "no debe reconocer el patron: sin linea,y con estación ambigua v2" do
    Metrotwitt.parse_twitt(create_twitt("Nuevo twitt de prueba #metroroto #cuatrocaminos "))
    assert_equal 0,Incident.all.size
    assert_equal 1, FailedTwitt.all.size
  end
  
  test "no debe reconocer el patron: otra cosa en vez de L o l para la linea" do
    Metrotwitt.parse_twitt(create_twitt("Nuevo twitt de prueba #metroroto #p2 #wadus "))
    assert_equal 0,Incident.all.size
    assert_equal 1, FailedTwitt.all.size
  end

  test "debe reconocer el patron: con line y ñ" do
    Metrotwitt.parse_twitt(create_twitt("Nuevo twitt de prueba #metroroto #l3 #plazadeespaña"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,3
    assert_equal Incident.last.station.nicename, 'plaza-de-espana'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba "
  end
  
  test "debe reconocer el patron: con line y ñ v3" do
    Metrotwitt.parse_twitt(create_twitt("Nuevo twitt de prueba #metroroto #l3 #plaza_de_españa"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,3
    assert_equal Incident.last.station.nicename, 'plaza-de-espana'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba "
  end
  
  test "debe reconocer el patron: con line y ñ v2" do
    Metrotwitt.parse_twitt(create_twitt("Nuevo twitt de prueba #metroroto #l3 #españa"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,3
    assert_equal Incident.last.station.nicename, 'plaza-de-espana'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba "
  end
  
  test "debe reconocer el patron: con line y y solo parte de la estación" do
    Metrotwitt.parse_twitt(create_twitt("Nuevo twitt de prueba #metroroto #l3 #plaza"))
    assert_equal 1,Incident.all.size
    assert_equal Incident.last.line.id,3
    assert_equal Incident.last.station.nicename, 'plaza-de-espana'
    assert_equal Incident.last.comment, "Nuevo twitt de prueba "
  end
  def create_twitt(text)
   Hashie::Mash.new({"text" => text,
     "created_at" => Time.now,
     "from_user" => "1111111",
     "id" => "12345678"
   })
  end


end

