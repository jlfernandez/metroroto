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
	    div_info ="<div class=\"map_pop\"><span class=\"station\">"+station+"</span><ul><li><a href=\"/lines/"+line+"\" class=\"line_number line_"+line+"\">"+line+"</a><p class=\"date\">"+date+"</p><p class=\"comment\"><span>Incidencia:</span> "+comment+"</p></li></ul></div>";
	    
	map.addOverlay(addInfoWindowToMarker(new GMarker(new GLatLng(lat,lng) , {title : 'Incidencia en línea'+line} ) , div_info ,{}));
  return false;
}





//DOMready
$(function(){

 //custom form elements
  $("select, input").uniform();
  
  $("#last_incidents span.timeago").timeago();
  
  //-------------------------------------------------------------------------
  // DROPDOWN MENU
  //-------------------------------------------------------------------------
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
  
  
  
  
  //-------------------------------------------------------------------------
  // VALIDATION AND AJAX OF NEW INCIDENT FORM
  //-------------------------------------------------------------------------
  var newIncidentSubmitHandler = {
    init: function(e){
      e.preventDefault();
       var form = $(this),
           e = e,
           validation_box = $('.validation_msg',form),
           incident = $('#incident_comment', form),
           button = $('button', form),
           button_txt = button.html(),
           show_msg = function(target, msg, success){
             target.removeClass('valid').fadeOut('slow', function(){
               if (success == true) { $(this).addClass('success') }else{ validation_box.removeClass('success') };
               $(this).html(msg).fadeIn();
             })
           },
           msg = '',
           success = true;

        form.unbind('submit').bind('submit', newIncidentSubmitHandler.disable);
        button.html('<span class="sending">Enviando...</span>');

       if (incident.valid() == false) {msg = '<span><strong>Ups!</strong>  Debes indicar la incidencia.</span>'; success = false; };

       if (success == true) {
         $.ajax({
          type: "POST",
          url: $(this).attr("action"),
          data: $.param(form.serializeArray()),
          success: function(html){
       	    $('#incidents').html(html);
       	    $("#last_incidents span.timeago").timeago();
            $.getJSON("/stations/"+$('#incident_station_id').val()+".json", function(json){
              new_marker( $('#incident_comment').val(),json.station.lat,json.station.long,$('#incident_line_id').val(),json.station.name);
              show_msg(validation_box, '<span>Gracias, por añadir la incidencia :)</span>', true);
              incident.val('');
              setTimeout(function(){
                $.scrollTo(0, 1000, {
                   easing : 'swing'
                 });
                 map.setCenter(new GLatLng(json.station.lat, json.station.long));
                 button.html(button_txt);
                 form.bind('submit', newIncidentSubmitHandler.init);
              }, 1500);
            });
          }
         })
       }else{
         show_msg(validation_box, msg);
       }
    },
    disable : function(e){
      e.preventDefault();
    }
  }
  
  //init
  $("#new_incident")
   .bind('submit', newIncidentSubmitHandler.init)
   .validate({
      rules : {
        "incident[comment]" : {
          required : true
        }
      }
    });
     
  
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
      
  
  
  
  //-------------------------------------------------------------------------
  // VALIDATION AND AJAX OF NEW SUBSCRIPTION FORM
  //-------------------------------------------------------------------------
  $("#new_subscription")
    .bind('submit', function(e){
      e.preventDefault();
      //init vars
      var form = $(this),
          mail = $('#subscription_email', form),
          lines = $('.lines li input', form),
          validation_box = $('.validation_msg',form),
          show_msg = function(target, msg){
            target.removeClass('valid').fadeOut('slow', function(){
              $(this).html(msg).fadeIn();
            })
          },
          msg = '',
          success = true;
      //set error messages
      if ( mail.valid() == false) { msg += '<span><strong>Ups!</strong>  Debes indicar un email valido.</span>'; success = false;}
      if ( lines.is(':checked') == false) { msg += '<span><strong>Ups!</strong> Debes indicar por lo menos una linea.</span>'; success = false; }
      // if all inputs are valid
      if (success == true) {
        $.ajax({
            data:$.param(form.serializeArray()),
            dataType:'script',
            type:'post',
            url: form.attr('action'),
            success : function(response){
                //show success info and hide button and prev error messages
                show_msg($('.wrap', form), '<strong class="success">Gracias! Te hemos añadido correctamente :)</strong>');
                $('button', form).hide();
                validation_box.hide();
              }
          });
      }else{
        //show error messages
        show_msg(validation_box, msg);
      }
      
    })
    //get checkboxes
    .find('.lines input')
    //toggle "select all" checkbox    
    .bind('change', function(e){
      var form =  $(this).closest('form'),
          checks = $('.lines input', form);
          
      if ($(this).attr('id') == 'line_ids_all') { // click en todos
         if ($(this).is(':checked')) checks.not(checks[0]).attr('checked', '');
       }else{ // click en el resto
         if ($(this).is(':checked'))  $(checks[0]).attr('checked', '');
      }
      $.uniform.update("#new_subscription .lines input"); 
      // form.trigger('submit');
    })
    //up to form 
    .end()
    //validation
    .validate({
       rules : {
         'subscription[email]' : {
           required : true,
           email : true
         }
       }
    });
  
   
    //-------------------------------------------------------------------------
    // ONLY INTERIOS PAGES
    //-------------------------------------------------------------------------
    
   $('#last_incidents .extra ').hide();
   $('.map_pop a.view_more, #last_incidents a.view_more').live('click', function(e){
     e.preventDefault();
     $('.extra', $(this).parent()).toggle();
     if ($(this).text() === 'ver más') {
       $(this).text('ocultar');
     }else{
       $(this).text('ver más');
     }
   });
   
   
   
   
    //-------------------------------------------------------------------------
    // ONLY INTERIOS PAGES
    //-------------------------------------------------------------------------
   if ($('body.page').length > 0){
     
     //-------------------------------------------------------------------------
     // AUTOFIT MAP ON INTERIOR  PAGES
     //------------------------------------------------------------------------- 
     var page_map = $('#map_canvas'),
         body = $(document),
         setMapHeight = function(wh){
           page_map.css('height', wh+'px');
         };
     setMapHeight(body.height()+30);
     
     
     //-------------------------------------------------------------------------
     // ONLY MAIN PAGES
     //-------------------------------------------------------------------------
   }else{
     
     //-------------------------------------------------------------------------
     // DYNAMIC POSITION OF CONTENT DEPENDING ON  WINDOW HEIGHT
     //-------------------------------------------------------------------------
     var setContentHeight = {
       target : $('#cont_wrap'),
       w_h : 0 ,
       w_h_fn : function(){ setContentHeight.w_h = $(window).height() },
       resize : function(w_h){
        if (setContentHeight.w_h < 870 ){
          var pos =  (w_h-80);
        }else{
          var pos =  850;
        }
        setContentHeight.target.stop().animate({top : pos+'px' }, 1000);
       },
       win_resize : function(){
        $(window).bind('resize', function(){
          setContentHeight.w_h_fn();  
          setContentHeight.resize(setContentHeight.w_h);
        })
       },
       init: function(){
         setContentHeight.w_h_fn();
         setContentHeight.resize(setContentHeight.w_h);
         setContentHeight.win_resize();
       }
     }
     setContentHeight.init();

     
   }
     

   
     

});