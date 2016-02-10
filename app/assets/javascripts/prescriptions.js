// if we're on the add prescription page, 
// check if we need to start a PA
function check_pa_required(drug_number, drug_name, patient_id) {
  data = { 
    drug_id: drug_number,
    drug_name: drug_name,
    patient_id: patient_id 
  };

  $.post("/pa_required", 
    data,
    function(data) {
      if (data.indicator.prescription.pa_required) {
        $('#prescription_pa_required').val(1);
        $('#pa_required_alert').removeClass('hidden');
        $('#pa_not_required_alert').addClass('hidden');
        $('#start_pa[type="checkbox"]').prop('checked', true);

        if (data.indicator.prescription.autostart) {
          $('#prescription_autostart').val(1);
          $('#start_pa[type="checkbox"]').prop('disabled', true);
          $('input[name="start_pa"][type=hidden]').val('1');
        }
        else {
          $('#start_pa[type="checkbox"]').prop('disabled', false);
          $('input[name="start_pa"][type=hidden]').val('0');
        }
      } 
      else {
        $('#pa_required_alert').addClass('hidden');
        $('#pa_not_required_alert').removeClass('hidden');
      }
    },
    'json');
}


