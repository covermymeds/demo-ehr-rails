$(function() {
  $("button#show-json-source").click(function() {
    $('#json-source').slideToggle();
  });

  $("[data-coded-reference='CoverMyMeds:signature-pad:1']").each(function(idx, el) {
    if (typeof(G_vmlCanvasManager) != 'undefined') {
      G_vmlCanvasManager.initElement(el);
      var ctx = el.getContext('2d');
    }
  })

  $("[data-coded-reference='CoverMyMeds:signature-pad:1']").signaturePad()

  $("[data-coded-reference='CoverMyMeds:form-search:1']").autocomplete({
      minLength: 3,
      source: function(request, response) {
        $.get("/forms?"+
          "drug_id="+$('#drug_id').val()+
          "&state="+$('#patient_state').val()+
          "&term="+request.term, 
          function(data, status){
            response(data);
          });
      },
      select: function(e, selected) {
        $("#form_id").val(selected.item.request_form_id);
        $("#form_name").val(selected.item.description);
        return false;
      },
      create: function () {
        $(this).data('ui-autocomplete')._renderItem = function (ul, item) {
          return $( "<li>" )
            .data( "ui-autocomplete-item", item.description )
            .append(item.description)
            .appendTo( ul );
          };
      }
    });

  // show all appropriate questions initially
  var formSelector = "div#form-block form"
  $(formSelector).questionVisibility({
    last: $(formSelector).attr('id')+"[END]"
  })

  // hide/show questions when selects and checkboxes are answered
  $(".question select, .question input[type='checkbox']").on("change", function(){
    $(formSelector).questionVisibility("changed", $(this))
  })

  $(formSelector).validate({
    onChange: true, // validate on change
    onBlur: true, // validate on blur
    eachValidField : function() {
      $(this).closest('div').removeClass('has-error');
      $(this).closest('div').removeClass('data-required');
    },
    eachInvalidField : function() {
      $(this).closest('div').removeClass('has-success').addClass('has-error');
    }
  })

});
