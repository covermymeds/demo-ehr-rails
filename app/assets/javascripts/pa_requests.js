$(function () {
  var options = window.config;

  var new_statuses = ["New"];
  var open_statuses = ["Appealed", "PA Request", "Shared", "Shared \\ Accessed Online", "Sent to Plan", "Question Request", "Question Response", "Cancel Request Sent", "Failure"];
  var closed_statuses = ["PA Response", "Provider Cancel", "Expired", "Archived" ];
  var appealed_statuses = ["Appeal Request", "Appeal Response", "Appealed"];
  var all_statuses = new_statuses.concat(open_statuses).concat(closed_statuses).concat(appealed_statuses);

  var dashboard_options = {
    apiId: options.apiId,
    apiUrl: options.apiUrl,
    version: 1,
    tokenIds: $('#dashboard').data('tokens'),
    folders: {
      'All':{ workflow_statuses: all_statuses, data: [] },
      'New': { workflow_statuses: new_statuses, data: [] },
      'Open': { workflow_statuses: open_statuses, data: [] },
      'Closed': { workflow_statuses: closed_statuses, data:[]},
      'Appeal': { workflow_statuses: appealed_statuses, data:[]},
    }
  };

  $('#dashboard').dashboard(dashboard_options);

  $("#prescription_drug_name").autocomplete({
    minLength: 4,
    source: '/drugs',
    select: function(e, selected) {
      $("#prescription_drug_number").val(selected.item.id);
      $("#prescription_drug_name").val(selected.item.full_name);
      return false;
    },
    change: function(e, ui) { 
      check_pa_required($('#prescription_drug_number').val(),
        $('#prescription_drug_name').val(),
        $('#prescription_patient_id').val());
    },
    create: function () {
      $(this).data('ui-autocomplete')._renderItem = function (ul, item) {
        return $("<li>").append(item.full_name).appendTo(ul);
      }
    }
  });

  $("#form_name").autocomplete({
    source: function(request, response) {
      $.get("/forms?"+
        "drug_id="+$("#prescription_drug_number").val()+
        "&state="+$("#pa_request_state").val()+
        "&term="+request.term, 
        function(data, status){
          response(data);
        })
    },
    select: function(e, selected) {
      $("#pa_request_form_id").val(selected.item.request_form_id);
      $("#form_name").val(selected.item.description);
      return false;
    },
    change: function(e, ui) { 
      check_pa_required(ui.val(), 
        $('#prescription_drug_name').val(),
        $('#prescription_patient_id').val());
    },
    create: function () {
      $(this).data('ui-autocomplete')._renderItem = function (ul, item) {
        return $("<li>").append(item.description).appendTo(ul);
      }
    }
  });


  $('.date').datepicker();

});
