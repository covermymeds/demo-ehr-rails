// if we're on the add prescription page, 
// check if we need to start a PA
function check_pa_required(drug_number, patient_id) {
  if(document.URL.indexOf('prescription') != -1) {
    debugger;
    data = { 
      prescriptions: [{ 
        'name': $('#prescription_drug_name').val(),
        'drug_id': $('#prescription_drug_number').val() }],
        patient_id: $('#prescription_patient_id').val() 
    };

    $.post("/pa_required", 
      data,
      function(data) {
        if (data.prescriptions[0].pa_required) {
          $('#pa_required_alert').removeClass('hidden');
        } 
        else {
          $('#pa_required_alert').addClass('hidden');
        }
        $('input[name="prescription[pa_required]"][type=hidden]').val(data.prescriptions[0].pa_required ? '1' : '0');
        $('#prescription_autostart').val(data.prescriptions[0].autostart ? '1' : '0');
        $('#prescription_pa_required').prop('checked', data.prescriptions[0].pa_required).prop('disabled', data.prescriptions[0].autostart);
      },
      'json');
    
    // $.ajax({
    //   method: "POST",
    //   url: '/pa_required',
    //   dataType: 'json',
    //   contentType: 'application/json',
    //   data: JSON.stringify(data),
    //   success: function(data) {
    //     if (data.prescriptions[0].pa_required) {
    //       $('#pa_required_alert').removeClass('hidden');
    //     } 
    //     else {
    //       $('#pa_required_alert').addClass('hidden');
    //     }
    //     $('input[name="prescription[pa_required]"][type=hidden]').val(data.prescriptions[0].pa_required ? '1' : '0');
    //     $('#prescription_autostart').val(data.prescriptions[0].autostart ? '1' : '0');
    //     $('#prescription_pa_required').prop('checked', data.prescriptions[0].pa_required).prop('disabled', data.prescriptions[0].autostart);
    //   }
    // });
  }
}


