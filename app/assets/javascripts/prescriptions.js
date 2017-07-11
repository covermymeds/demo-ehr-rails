// if we're on the add prescription page,
// check if we need to start a PA
function check_pa_required(drug_number, drug_name, patient_id, pharmacy_id) {
  data = {
    drug_id: drug_number,
    drug_name: drug_name,
    patient_id: patient_id,
    pharmacy_id: pharmacy_id
  };

  $.post("/pa_required",
    data,
    function(data) {
      if (data.indicator.prescription.pa_required) {
        $('#prescription_pa_required').val(1);
        $('#pa_required_message').removeClass('hidden');
        $('#pa_not_required_message').addClass('hidden');
        $('#check_pa_message').addClass('hidden');
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
        $('#pa_required_message').addClass('hidden');
        $('#pa_not_required_message').removeClass('hidden');
        $('#check_pa_message').addClass('hidden');
      }

      var panel_row_custom = document.getElementById('panel_row_custom');
      panel_row_custom.innerHTML = '';
      var html = '';
      html += "<h3>" + data.indicator.messages.headline + "</h3>";
      var div = document.createElement('div');
      div.innerHTML = html;
      panel_row_custom.appendChild(div);

      var rxbc_info = document.getElementById('rxbc_info')
      if (rxbc_info != null) {
        rxbc_info.remove();
      };

      var panel_body_html = '';
      var panel_body = document.getElementById('panel-body');
      panel_body_html = "<div id='rxbc_info' class='panel-rxbc-info'>";
      panel_body_html += "<div class='row'>" + data.indicator.messages.drug.headline + "</div>";
      panel_body_html += "<div class='row'>" + data.indicator.messages.drug.form + "</div>";
      panel_body_html += "<div class='row rxbc-row-custom'>" + data.indicator.messages.drug.quantity + "</div>";
      if (data.indicator.messages.pharmacy.headline != null){
        panel_body_html += "<div class='row'>" + data.indicator.messages.pharmacy.headline + "</div>";
        panel_body_html += "<div class='row'>" + data.indicator.messages.pharmacy.address.street_1 + "</div>";
        if (data.indicator.messages.pharmacy.address.city != "" && data.indicator.messages.pharmacy.address.city != "") {
          panel_body_html += "<div class='rxbc-row-custom'>" + data.indicator.messages.pharmacy.address.city + ", " +  data.indicator.messages.pharmacy.address.state + " " + data.indicator.messages.pharmacy.address.zip + "</div>";
        }
      };
      panel_body_html += "<div class='row rxbc-small-font'><em>" + data.indicator.messages.footer.text + "</em></div>";
      panel_body_html += "<img src=" + data.indicator.messages.footer.logo.small + " class='col-md-5 pull-right'></div>";
      var panel_body_div = document.createElement('div');
      panel_body_div.innerHTML = panel_body_html;
      panel_body.appendChild(panel_body_div);
    },
    'json');
}
