// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function addInfoWindowToMarker(marker,info,options){
	GEvent.addListener(marker, "click", function() {marker.openInfoWindowHtml(info,options);});
	return marker;
}


var getFirstandLastStation = {
  start_station : $('#start_station'),
  end_station : $('#end_station'),
  start_station_label : $('label', $('#start_station').closest('span')),
  end_station_label : $('label', $('#end_station').closest('span')),
  change : function(j){
    getFirstandLastStation.start_station.val(j[0][1]);
    getFirstandLastStation.start_station_label.html(j[0][0]);
    getFirstandLastStation.end_station.val(j[(j.length)-1][1]);
    getFirstandLastStation.end_station_label.html(j[(j.length)-1][0]);
  }
}


var map; 
function new_marker(comment, lat, lng, line, station) {
	var now = new Date(),
	    date = now.getDate() + " de " + (now.getMonth() +1) + " de " + now.getFullYear() + " " + now.getHours() + ":" + now.getMinutes(),
	    div_info ="<div class=\"map_pop\"><p><span class=\"line_number line_"+line+"\">"+line+"</span><span class=\"station\">"+station+"</span></p><p class=\"date\">"+date+"</p><p class=\"comment\">Incidencia:     "+comment+"</p></div>";
	map.addOverlay(addInfoWindowToMarker(new GMarker(new GLatLng(lat,lng) , {title : 'Incidencia en línea'+line} ) , div_info ,{}));
  return false;
}





//DOMready
$(function(){
  
   //custom form elements
   $("select, input").uniform();
   
   
   //new incident form - get stations from a line
   $('select#incident_line_id').change(function(){
     $.getJSON("lines/"+ $(this).val() +"/stations", function(j){
        var options = '';
        for (var i = 0; i < j.length; i++) {
          options += '<option value="' + j[i][1] + '">' + j[i][0] + '</option>';
        }
        getFirstandLastStation.change(j);
        $("select#incident_station_id'").html(options);
        
        $.uniform.update("#incident_station_id"); 
      })
   });
   
   
   
   //new incident form , ajax submit
   $('#new_incident').bind('submit',function(e){
      e.preventDefault();
      if ($(this).valid()) {
        $.ajax({
   	    type: "POST",
   	    url: $(this).attr("action"),
   	    data: "incident[comment]="+$('#incident_comment').val()+"&incident[line_id]="+$('#incident_line_id').val()+"&incident[station_id]="+$('#incident_station_id').val()+"&incident[direction_id]="+$("input:checked[type='radio'][name='incident[direction]']").val(),
   	    success: function(html){
   	 	  $('#incidents').html(html); 
   	      $.getJSON("/stations/"+$('#incident_station_id').val()+".json", function(json){
   	        new_marker( $('#incident_comment').val(),json.station.lat,json.station.long,$('#incident_line_id').val(),json.station.name)
   	      })
   	    }
        })
      };
      
   })
   
   
   
   
   var dropDownMenu = {
     target : $('#header ul li.lines'),
     submenu : function(){
       dropDownMenu.submenu = $('ul', dropDownMenu.target);
     },
     init: function(){
       dropDownMenu.submenu();
       dropDownMenu.target
        .bind('mouseover', function(){
          dropDownMenu.submenu.show();
         })
        .bind('mouseleave', function(e){
           if ($(e.target) != dropDownMenu.submenu) {
             dropDownMenu.submenu.hide()
           };
         })
        dropDownMenu.submenu.bind('mouseleave', function(e){
          if($(e.target) != dropDownMenu.target){
           dropDownMenu.submenu.hide();
          }
        })
     }
     
   }
   
   dropDownMenu.init();
   

   
   
   
     $("#new_incident").validate({
        success: function(label) {
          var message = '&nbsp;'; // set &nbsp; as text for IE
          label.closest("p").removeClass("error");
          $("span.error", label.closest("p")).remove();
          label.html(message).addClass("valid");
        },
        highlight: function(element, errorClass) {
          $(element).closest("p").addClass("error");
          $("span.error", $('#'+element.id).closest("p")).remove();
          switch(element.id){
            case "incident_comment":
              $(element).after("<span class='error'>Ups! Debes escribir la incidencia.</span>")
            break;
            case "incident_line_id":
              $(element).after("<span class='error'>Ups! Debes indicar una línea.</span>")
            break;
            case "incident_station_id":
              $(element).after("<span class='error'>Ups! Debes indicar una estación.</span>")
            break;
          }
        },
        rules : {
          'incident[comment]' : {
            required : true
          },
          'incident[line_id]' : {
            required : true
          },
          'incident[station_id]' : {
            required : true
          }
        }
      });
      
      // $("#new_subscription").validate({
      //     success: function(label) {
      //       var message = '&nbsp;'; // set &nbsp; as text for IE
      //       label.closest("p").removeClass("error");
      //       $("span.error", label.closest("p")).remove();
      //       label.html(message).addClass("valid");
      //     },
      //     highlight: function(element, errorClass) {
      //       $(element).closest("p").addClass("error");
      //       $("span.error", $('#'+element.id).closest("p")).remove();
      //       switch(element.id){
      //         case "subscription_email":
      //           $(element).after("<span class='error'>Ups! Debes escribir la incidencia.</span>")
      //         break;
      //         case "line_ids_all":
      //         
      //           $(element).closest('form').append.("<span class='error'>Ups! Debes indicar una línea.</span>")
      //         break;
      //       }
      //     },
      //     rules : {
      //       'subscription[email]' : {
      //         required : true,
      //         email : true
      //       },
      //       'line_ids[all]' : {
      //         required : true            }
      //     }
      //   });
      
      
   
   
   
   

});