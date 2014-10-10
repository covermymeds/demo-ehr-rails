$(function() {
  $("button#show-json-source").click(function() {
    $('#json-source').slideToggle();
  });

  $("[data-coded-reference='CoverMyMeds:signature-pad:1']").signaturePad()

  if ($("[data-coded-reference='CoverMyMeds:form-search:1']").size()) {
    $("[data-coded-reference='CoverMyMeds:form-search:1']").formSearch({
      apiId: window.config.apiId,
      version: 1,
      drugId: $('#drug_id').val(),
      state: $('#patient_state').val()
    })
  }

  // initialize question visibility
  var formSelector = "div#form-block form"
  $(formSelector).questionVisibility({
    last: $(formSelector).attr('id')+"[END]"
  })
  
  // on change hide/show questions
  var decision = ".question select, .question input[type='checkbox']"
  $(decision).on("change", function(){
    $(formSelector).questionVisibility("changed", $(this))
  })

  $(formSelector).validate({
        onKeyup : true,
        eachValidField : function() {
          $(this).closest('div').removeClass('has-error').addClass('has-success');
        },
        eachInvalidField : function() {
          $(this).closest('div').removeClass('has-success').addClass('has-error');
        }
      })

});
