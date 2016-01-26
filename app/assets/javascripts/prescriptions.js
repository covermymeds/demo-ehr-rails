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
        $('#pa_required_alert').removeClass('hidden');
      } 
      else {
        $('#pa_required_alert').addClass('hidden');
      }
      $('input[name="prescription[pa_required]"][type=hidden]').val(data.indicator.prescription.pa_required ? '1' : '0');
      $('#prescription_autostart').val(data.indicator.prescription.autostart ? '1' : '0');
      $('#prescription_pa_required').prop('checked', data.indicator.prescription.pa_required).prop('disabled', data.indicator.prescription.autostart);
    },
    'json');
}


