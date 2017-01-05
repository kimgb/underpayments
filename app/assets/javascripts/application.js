// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .
//
//= require select2
function remove_fields(link) {
  $(link).previous("input[type=hidden]").value = "1";
  $(link).up(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).up().insert({
    before: content.replace(regexp, new_id)
  });
}

// excuse the JQuery
$(document).ready(function(){
  $(".add_fields").on("click", function(e){
    var time = new Date().getTime();
    var regexp = new RegExp($(this).data('id'), 'g');
    
    e.preventDefault();
    
    $(this).before($(this).data('fields').replace(regexp, time));
  })
})
//link_to(name, "#", class: "add_fields", data: { id: new_object.object_id, fields: fields.gsub("\n", "") })
