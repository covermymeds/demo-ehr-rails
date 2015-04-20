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

  if ($("[data-coded-reference='CoverMyMeds:form-search:1']").size()) {
    $("[data-coded-reference='CoverMyMeds:form-search:1']").formSearch({
      apiId: window.config.apiId,
      apiUrl: window.config.apiUrl,
      version: 1,
      drugId: $('#drug_id').val(),
      state: $('#patient_state').val()
    })
  }

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
          $(this).closest('div').removeClass('has-error').addClass('has-success');
          $(this).closest('div').removeClass('data-required');
        },
        eachInvalidField : function() {
          $(this).closest('div').removeClass('has-success').addClass('has-error');
        }
      })

});
