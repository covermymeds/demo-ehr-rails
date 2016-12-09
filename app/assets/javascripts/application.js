// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery-validate

// Loads all Bootstrap javascripts
//= require bootstrap
//= require bootstrap-datepicker
//= require underscore
//= require signature
//= require cocoon
//= require_tree .

$(function() {

  var options = window.config;

  // make notices flash away, while errors stay
  $('.alert-info').delay(500).fadeIn('normal', function() {
      $(this).delay(1500).fadeOut();
  });

  $('.alert-error').delay(500).fadeIn('normal', null);

  $('select#change_view').change(function() {
    $('#custom_ui_form').submit();
  })

});
