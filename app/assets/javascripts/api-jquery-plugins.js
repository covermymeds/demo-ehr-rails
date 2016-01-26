/*jslint sloppy: true, nomen: true, white: true */
/*global window: false, _: false */
(function() {
    window.JST = {};

    window.JST.dashboard = _.template([
        '<div class="row">',
          '<div class="navigation col-md-3">',
            '<div class="order btn-group btn-group-justified">',
              '<div class="btn-group"><button type="button" data-direction="desc" class="btn btn-default active">Newest First</button></div>',
              '<div class="btn-group"><button type="button" data-direction="asc" class="btn btn-default">Oldest First</button></div>',
            '</div>',
            '<hr>',
            '<ul class="folders nav nav-pills nav-stacked">',
            '<% _.each(folders, function (folder, name) { %>',
              '<li class="<%= name === currentFolder ? "active" : "" %>"><a href="#<%= name %>"><span class="glyphicon glyphicon-folder-close"></span> <%= name %> <span class="badge pull-right"><%= folder.data.length %></span></a></li>',
              '<% }); %>',
            '</ul>',
            '<hr>',
            '<form action="#" class="well" method="get" role="form">',
              '<fieldset>',
                '<legend>Search</legend>',
                  '<div class="input-group">',
                    '<input class="form-control search" name="q" placeholder="Search" type="search">',
                    '<span class="input-group-btn">',
                      '<button class="clear btn btn-default" type="button"><span class="clear glyphicon glyphicon-remove"></span></button>',
                    '</span>',
                  '</div>',
              '</fieldset>',
            '</form>',
          '</div>',
          '<div class="content col-md-9">',
          '</div> <!-- /.content -->',
        '</div> <!-- /.row -->'
        ].join(''));

window.JST.dashboardContent = _.template([
    '<table class="table table-striped requests">',
    '<% if (requests.length === 0) { %>',
      '<tr>',
        '<td><h4>No Results</h4></td>',
      '</tr>',
    '<% } %>',
    '<% _.each(requests, function (request) { %>',
      '<tr>',
        '<td class="form-thumbnail">',
        '<% if (request.form_id) { %>',
        '<img src="https://www.covermymeds.com/forms/pdf/thumbs/90/highmark_west_virginia_prescription_drug_medication_6827.jpg">',
        '<% } else { %>',
        '<img src="https://www.covermymeds.com/styles_r2/images/pick_the_form.png">',
        '<% } %>',
        '</td>',
        '<td>',
          '<h4><%= request.patient.first_name %> <%= request.patient.last_name %> (Key: <%= request.id %>)</h4>',
          '<h5>Owner: <span class="label label-info"><%= request.memo %></span></h5>'+
          '<dl class="dl-horizontal request-details">',
            '<dt>Status</dt><dd><span class="label label-info"><%= request.workflow_status %></span></dd>',
            '<dt>Drug</dt><dd><%= request.prescription.name || "(Missing)" %></dd>',
            '<dt>Created</dt><dd><%= new Date(Date.parse(request.created_at)).toLocaleDateString() %></dd>',
            '<dt>Link</dt><dd><a href="<%= request.tokens[0].html_url %>">View on CoverMyMeds.com &rarr;</a></dd>',
          '</dl>',
        '</td>',
      '</tr>',
      '<% }); %>',
    '</table>',
    '<% if (totalPages > 0) { %>',
    '<ul class="pagination">',
    '<% function insideWindow(page, currentPage) {',
          'var window = 2;',
          'return Math.abs(currentPage - page) <= window;',
        '} %>',
        '<% i = 0; %>',
        '<li class="<%= (i === currentPage) ? "active" : "" %>"><a href="<%= i %>"><%= (i + 1) %></a></li>',
        '<% if (!insideWindow(i + 1, currentPage)) { %>',
        '<li><a href="#">&hellip;</a></li>',
        '<% } %>',
        '<% for (i = 1; i <= totalPages - 1; i += 1) {',
          'if (insideWindow(i, currentPage)) { %>',
        '<li class="<%= (i === currentPage) ? "active" : "" %>"><a href="<%= i %>"><%= (i + 1) %></a></li>',
        '<% }',
        '} %>',
        '<% i = totalPages; %>',
        '<% if (!insideWindow(i - 1, currentPage)) { %>',
        '<li><a href="#">&hellip;</a></li>',
        '<% } %>',
        '<li class="<%= (i === currentPage) ? "active" : "" %>"><a href="<%= i %>"><%= (i + 1) %></a></li>',
        '</ul>',
    '<% } %>'
    ].join(''));

window.JST.formsearch = _.template([
    '<table class="table">',
      '<tr>',
        '<td><img src="<%= form.thumbnail_url %>"></td>',
        '<td><%= form.text %></td>',
      '</tr>',
    '</table>'
    ].join(''));

window.JST.action_button = function(obj) {
    obj || (obj = {});
    var __t, __p = '', __e = _.escape;
    with (obj) {
        __p += '<button class=\'' +
        ((__t = ( action.slug() )) == null ? '' : __t) +
        ' btn\'>' +
        ((__t = ( action.title )) == null ? '' : __t) +
        '</button>\n';

    }
    return __p
};

window.JST.action_link = function(obj) {
    obj || (obj = {});
    var __t, __p = '', __e = _.escape;
    with (obj) {
        __p += '<a class=\'' +
        ((__t = ( action.slug )) == null ? '' : __t) +
        ' btn\' href=\'' +
        ((__t = ( action.href )) == null ? '' : __t) +
        '\'>' +
        ((__t = ( action.title )) == null ? '' : __t) +
        '</a>\n';

    }
    return __p
};

window.JST.checkbox_question = function(obj) {
    obj || (obj = {});
    var __t, __p = '', __e = _.escape;
    with (obj) {
        __p += '<div class="question checkbox ' +
        ((__t = ( question.isRequired() )) == null ? '' : __t) +
        '">\n  <label for="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '">\n\n    <input type="checkbox"\n           id="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n           name="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n           value="' +
        ((__t = ( question.checked_value )) == null ? '' : __t) +
        '"\n           ' +
        ((__t = ( question.isRequired() )) == null ? '' : __t) +
        '\n    />\n    ' +
        ((__t = ( question.questionText() )) == null ? '' : __t) +
        '\n\n  </label>\n</div>\n\n';

    }
    return __p
};

window.JST.choice_question = function(obj) {
    obj || (obj = {});
    var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
    function print() { __p += __j.call(arguments, '') }
    with (obj) {
        __p += '<div class="question choice ' +
        ((__t = ( question.isRequired() )) == null ? '' : __t) +
        '">\n  <label for="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '">\n    ' +
        ((__t = ( question.questionText() )) == null ? '' : __t) +
        '\n  </label>\n\n  <select id="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n          name="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n          ' +
        ((__t = ( question.selectMultiple() )) == null ? '' : __t) +
        ' >\n    ';
        question.choices().forEach( function(choice){ ;
            __p += '\n      <option value="' +
            ((__t = ( choice.choice_id )) == null ? '' : __t) +
            '"\n              ' +
            ((__t = ( question.isSelected(choice) )) == null ? '' : __t) +
            ' >\n        ' +
            ((__t = ( choice.choice_text )) == null ? '' : __t) +
            '\n      </option>\n    ';
        }); ;
        __p += '\n  </select>\n\n</div>\n';

    }
    return __p
};

window.JST.date_question = function(obj) {
    obj || (obj = {});
    var __t, __p = '', __e = _.escape;
    with (obj) {
        __p += '<div class="question date ' +
        ((__t = ( question.isRequired() )) == null ? '' : __t) +
        '">\n  <label for="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '">\n    ' +
        ((__t = ( question.questionText() )) == null ? '' : __t) +
        '\n  </label>\n\n  <input type="date"\n         id="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n         name="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n         value="' +
        ((__t = ( question.value )) == null ? '' : __t) +
        '"\n         ' +
        ((__t = ( question.isRequired() )) == null ? '' : __t) +
        '\n  />\n</div>\n';

    }
    return __p
};

window.JST.file_question = function(obj) {
    obj || (obj = {});
    var __t, __p = '', __e = _.escape;
    with (obj) {
        __p += '<div class="question file ' +
        ((__t = ( question.isRequired() )) == null ? '' : __t) +
        '">\n  <label for="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '">\n    ' +
        ((__t = ( question.questionText() )) == null ? '' : __t) +
        '\n  </label>\n\n  <input type="file"\n         id="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n         name="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n         value="' +
        ((__t = ( question.value )) == null ? '' : __t) +
        '"\n         ' +
        ((__t = ( question.isRequired() )) == null ? '' : __t) +
        '\n  />\n</div>\n\n';

    }
    return __p
};

window.JST.form = function(obj) {
    obj || (obj = {});
    var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
    function print() { __p += __j.call(arguments, '') }
    with (obj) {
        __p += '<form class=\'request-pages-form\' method="POST">\n  ';
        form.questionSets.forEach( function(questionSet) { ;
            __p += '\n    ' +
            ((__t = ( questionSet.render() )) == null ? '' : __t) +
            '\n  ';
        }); ;
        __p += '\n\n  <fieldset class=\'controls\'>\n    <input type=\'hidden\' class=\'form_action\' name=\'form_action\' value=\'\' />\n\n    ';
        form.actions.forEach( function(action) { ;
            __p += '\n      ' +
            ((__t = ( action.render() )) == null ? '' : __t) +
            '\n    ';
        }); ;
        __p += '\n  </fieldset>\n</form>\n';

    }
    return __p
};

window.JST.free_area_question = function(obj) {
    obj || (obj = {});
    var __t, __p = '', __e = _.escape;
    with (obj) {
        __p += '<div class="question free-area ' +
        ((__t = ( question.isRequired() )) == null ? '' : __t) +
        '">\n  <label for="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '">\n    ' +
        ((__t = ( question.questionText() )) == null ? '' : __t) +
        '\n  </label>\n\n  <textarea\n    id="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n    name="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n    placeholder="' +
        ((__t = ( question.placeholder() )) == null ? '' : __t) +
        '"\n    ' +
        ((__t = ( question.isRequired() )) == null ? '' : __t) +
        ' >\n\n    ' +
        ((__t = ( question.value )) == null ? '' : __t) +
        '\n\n  </textarea>\n</div>\n';

    }
    return __p
};

window.JST.free_text_question = function(obj) {
    obj || (obj = {});
    var __t, __p = '', __e = _.escape;
    with (obj) {
        __p += '<div class="question free-text ' +
        ((__t = ( question.isRequired() )) == null ? '' : __t) +
        '">\n  <label for="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '">\n    ' +
        ((__t = ( question.questionText() )) == null ? '' : __t) +
        '\n  </label>\n\n  <input type="text"\n         id="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n         name="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n         value="' +
        ((__t = ( question.value )) == null ? '' : __t) +
        '"\n         placeholder="' +
        ((__t = ( question.placeholder() )) == null ? '' : __t) +
        '"\n         ' +
        ((__t = ( question.isRequired() )) == null ? '' : __t) +
        '\n  />\n</div>\n';

    }
    return __p
};

window.JST.hidden_question = function(obj) {
    obj || (obj = {});
    var __t, __p = '', __e = _.escape;
    with (obj) {
        __p += '<input type="hidden"\n  id="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n  name="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n  value="' +
        ((__t = ( question.value )) == null ? '' : __t) +
        '"\n/>\n';

    }
    return __p
};

window.JST.numeric_question = function(obj) {
    obj || (obj = {});
    var __t, __p = '', __e = _.escape;
    with (obj) {
        __p += '<div class="question numeric ' +
        ((__t = ( question.isRequired() )) == null ? '' : __t) +
        '">\n  <label for="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '">\n    ' +
        ((__t = ( question.questionText() )) == null ? '' : __t) +
        '\n  </label>\n\n  <input type="number"\n         id="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n         name="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '"\n         value="' +
        ((__t = ( question.value )) == null ? '' : __t) +
        '"\n         ' +
        ((__t = ( question.isRequired() )) == null ? '' : __t) +
        '\n  />\n</div>\n';

    }
    return __p
};

window.JST.question_set = function(obj) {
    obj || (obj = {});
    var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
    function print() { __p += __j.call(arguments, '') }
    with (obj) {
        __p += '<fieldset class=\'question-set\'>\n  <legend>' +
        ((__t = ( questionSet.title )) == null ? '' : __t) +
        '</legend>\n  ';
        questionSet.questions.forEach( function(question) { ;
            __p += '\n    ' +
            ((__t = ( question.render() )) == null ? '' : __t) +
            '\n  ';
        }); ;
        __p += '\n</fieldset>\n';

    }
    return __p
};

window.JST.statement_question = function(obj) {
    obj || (obj = {});
    var __t, __p = '', __e = _.escape;
    with (obj) {
        __p += '<div class="question statement">\n  <label for="' +
        ((__t = ( question.questionId() )) == null ? '' : __t) +
        '">\n    ' +
        ((__t = ( question.questionText() )) == null ? '' : __t) +
        '\n  </label>\n\n  <p>\n    ' +
        ((__t = ( question.content_html() )) == null ? '' : __t) +
        '\n  </p>\n</div>\n';

    }
    return __p
};

window.JST.unknown_question = function(obj) {
    obj || (obj = {});
    var __t, __p = '', __e = _.escape;
    with (obj) {
        __p += '<div class="question">\n  Something went wrong (I don\'t know how to display a question of type "' +
            ((__t = ( question.questionType() )) == null ? '' : __t) +
            '").\n</div>\n';

}
return __p
};


}(window));

/*jslint sloppy: true, unparam: true, todo: true, nomen: true */
/*global jQuery: false, CMM_API_CONFIG: false, Base64: false, _: false */
(function ($) {
    $.fn.extend({
        formSearch: function (options) {
            options = options || {};

            // Remove plugins/event handlers
            if (options === 'destroy') {
                return this.each(function () {
                    $(this).select2('destroy');
                });
            }

            return this.each(function () {
                var defaultUrl;

                defaultUrl = options.apiUrl + '/forms?v=' + options.version;

                // Initialize select2
                $(this).select2({
                    placeholder: 'Plan, PBM, Form name, BIN, or Contract ID',
                    minimumInputLength: 4,
                    ajax: {
                        quietMillis: 250,
                        url: options.url || defaultUrl,
                        transport: function (params) {
                            // Add authorization header if directly querying API;
                            // otherwise we assume our custom URL will handle authorization
                            if (!options.url) {
                                params.beforeSend = function (xhr) {
                                    xhr.setRequestHeader('Authorization', 'Basic ' + Base64.encode(options.apiId + ':x-no-pass'));
                                };
                            }

                            return $.ajax(params);
                        },
                        data: function (term, page) {
                            var state,
                                drugId;

                            // Values are either passed in to plugin constructor, or
                            // taken from input fields that conform to naming convention
                            state = options.state || $('select[name="request[state]"]').val();
                            drugId = options.drugId || $('input[name="request[prescription][drug_id]"]').val();

                            return {
                                q: term,
                                state: state,
                                drug_id: drugId
                            };
                        },
                        results: function (data, page) {
                            var results = [],
                                more,
                                i,
                                j;

                            more = (page * 10) < data.total;
                            for (i = 0, j = data.forms.length; i < j; i += 1) {
                                results.push({
                                    id: data.forms[i].request_form_id,
                                    text: data.forms[i].description,
                                    thumbnail_url: data.forms[i].thumbnail_url
                                });
                            }

                            return {
                                results: results,
                                more: more
                            };
                        }
                    },
                    formatResult: function (form) {
                        return JST.formsearch({ form: form });
                    }
                });
            });
        }
    });
}(jQuery));

/*jslint sloppy: true, unparam: true, todo: true */
/*global alert: false, jQuery: false, CMM_API_CONFIG: false, Base64: false */
(function ($) {
    $.fn.extend({
        drugSearch: function (options) {
            options = options || {};

            // Remove plugins/event handlers
            if (options === 'destroy') {
                return this.each(function () {
                    $(this).select2('destroy');
                });
            }

            return this.each(function () {
                var defaultUrl;

                defaultUrl = options.apiUrl + '/drugs?v=' + options.version;

                // Initialize select2
                $(this).select2({
                    placeholder: 'Begin typing the medication name and select from list',
                    minimumInputLength: 4,
                    ajax: {
                        quietMillis: 250,
                        url: options.url || defaultUrl,
                        transport: function (params) {
                            // Add authorization header if directly querying API;
                            // otherwise we assume our custom URL will handle authorization
                            if (!options.url) {
                                params.beforeSend = function (xhr) {
                                    xhr.setRequestHeader('Authorization', 'Basic ' + Base64.encode(options.apiId + ':x-no-pass'));
                                };
                            }

                            return $.ajax(params);
                        },
                        data: function (term, page) {
                            return {
                                q: term
                            };
                        },
                        results: function (data, page) {
                            var results = [],
                                more,
                                i,
                                j;

                            more = (page * 10) < data.total;

                            for (i = 0, j = data.drugs.length; i < j; i += 1) {
                                results.push({
                                    text: data.drugs[i].full_name,
                                    id: data.drugs[i].id
                                });
                            }

                            return {
                                results: results,
                                more: more
                            };
                        }
                    }
                });
            });
        }
    });
}(jQuery));

/*jslint sloppy: true, unparam: true, todo: true */
/*global jQuery: false, CMM_API_CONFIG: false, Base64: false */
(function ($) {
    $.fn.extend({
        createRequest: function (options) {
            options = options || {};

            // Remove event handler created by this plugin
            if (options === 'destroy') {
                return this.each(function () {
                    $(this).off('click');
                });
            }

            return this.each(function () {
                var defaultUrl,
                    button,
                    active;

                defaultUrl = options.apiUrl + '/requests?v=' + options.version;

                button = $(this);
                active = false;

                // Attach event handler
                button.on('click', function (event) {
                    event.preventDefault();

                    // Prevent duplicate/multiple clicks
                    if (active === true) {
                        return;
                    }

                    button.attr('disabled', 'disabled');
                    active = true;

                    // To create a PA request, either pass a "data" attribute in the options object,
                    // or create form elements that conform to the API data naming convention
                    var dataFromFormElements = {
                        "request": {
                            "urgent": $('input[name="request[urgent]"]').attr('checked'),
                            "form_id": $('input[name="request[form_id]"]').val(),
                            "state": $('select[name="request[state]"]').val(),
                            "patient": {
                                "first_name": $('input[name="request[patient][first_name]"]').val(),
                                "middle_name": $('input[name="request[patient][middle_name]"]').val(),
                                "last_name": $('input[name="request[patient][last_name]"]').val(),
                                "date_of_birth": $('input[name="request[patient][date_of_birth]"]').val(),
                                "gender": $('select[name="request[patient][gender]"]').val(),
                                "email": $('input[name="request[patient][email]"]').val(),
                                "member_id": $('input[name="request[patient][member_id]"]').val(),
                                "phone_number": $('input[name="request[patient][phone_number]"]').val(),
                                "address": {
                                    "street_1": $('input[name="request[patient][address][street_1]"]').val(),
                                    "street_2": $('input[name="request[patient][address][street_2]"]').val(),
                                    "city": $('input[name="request[patient][address][city]"]').val(),
                                    "state": $('select[name="request[patient][address][state]"]').val(),
                                    "zip": $('input[name="request[patient][address][zip]"]').val()
                                }
                            },
                            "payer": {
                                "form_search_text": $('input[name="request[payer][form_search_text]"]').val(),
                                "bin": $('input[name="request[payer][bin]"]').val(),
                                "pcn": $('input[name="request[payer][pcn]"]').val(),
                                "group_id": $('input[name="request[payer][group_id]"]').val(),
                                "medical_benefit_name": $('input[name="request[payer][medical_benefit_name]"]').val(),
                                "drug_benefit_name": $('input[name="request[payer][drug_benefit_name]"]').val(),
                            },
                            "prescriber": {
                                "npi": $('input[name="request[prescriber][npi]"]').val(),
                                "first_name": $('input[name="request[prescriber][first_name]"]').val(),
                                "last_name": $('input[name="request[prescriber][last_name]"]').val(),
                                "clinic_name": $('input[name="request[prescriber][clinic_name]"]').val(),
                                "address": {
                                    "street_1": $('input[name="request[prescriber][address][street_1]"]').val(),
                                    "street_2": $('input[name="request[prescriber][address][street_2]"]').val(),
                                    "city": $('input[name="request[prescriber][address][city]"]').val(),
                                    "state": $('select[name="request[prescriber][address][state]"]').val(),
                                    "zip": $('input[name="request[prescriber][address][zip]"]').val()
                                },
                                "fax_number": $('input[name="request[prescriber][fax_number]"]').val(),
                                "phone_number": $('input[name="request[prescriber][phone_number]"]').val()
                            },
                            "prescription": {
                                "drug_id": $('input[name="request[prescription][drug_id]"]').val(),
                                "strength": $('input[name="request[prescription][strength]"]').val(),
                                "frequency": $('input[name="request[prescription][frequency]"]').val(),
                                "enumerated_fields": $('input[name="request[prescription][enumerated_fields]"]').val(),
                                "refills": $('input[name="request[prescription][refills]"]').val(),
                                "dispense_as_written": $('input[name="request[prescription][dispense_as_written]"]').val(),
                                "quantity": $('input[name="request[prescription][quantity]"]').val(),
                                "days_supply": $('input[name="request[prescription][days_supply]"]').val()
                            },
                            "pharmacy": {
                                "name": $('input[name="request[pharmacy][name]"]').val(),
                                "address": {
                                    "street_1": $('input[name="request[pharmacy][address][street_1]"]').val(),
                                    "street_2": $('input[name="request[pharmacy][address][street_2]"]').val(),
                                    "city": $('input[name="request[pharmacy][address][city]"]').val(),
                                    "state": $('select[name="request[pharmacy][address][state]"]').val(),
                                    "zip": $('input[name="request[pharmacy][address][zip]"]').val()
                                },
                                "fax_number": $('input[name="request[pharmacy][fax_number]"]').val(),
                                "phone_number": $('input[name="request[pharmacy][phone_number]"]').val()
                            },
                            "enumerated_fields": {
                                "icd9_0": $('input[name="request[enumerated_fields][icd9_0]"]').val(),
                                "icd9_1": $('input[name="request[enumerated_fields][icd9_1]"]').val(),
                                "icd9_2": $('input[name="request[enumerated_fields][icd9_2]"]').val(),
                                "failed_med_0": $('input[name="request[enumerated_fields][failed_med_0]"]').val(),
                                "failed_med_1": $('input[name="request[enumerated_fields][failed_med_1]"]').val(),
                                "failed_med_2": $('input[name="request[enumerated_fields][failed_med_2]"]').val(),
                                "failed_med_3": $('input[name="request[enumerated_fields][failed_med_3]"]').val(),
                                "failed_med_4": $('input[name="request[enumerated_fields][failed_med_4]"]').val(),
                                "failed_med_5": $('input[name="request[enumerated_fields][failed_med_5]"]').val(),
                                "failed_med_6": $('input[name="request[enumerated_fields][failed_med_6]"]').val(),
                                "failed_med_7": $('input[name="request[enumerated_fields][failed_med_7]"]').val(),
                                "failed_med_8": $('input[name="request[enumerated_fields][failed_med_8]"]').val(),
                                "failed_med_9": $('input[name="request[enumerated_fields][failed_med_9]"]').val()
                            }
                        }
                    };

                    $.ajax({
                        url: options.url || defaultUrl,
                        type: 'POST',
                        beforeSend: function (xhr, settings) {
                            if (!options.url) {
                                xhr.setRequestHeader('Authorization', 'Basic ' + Base64.encode(options.apiId + ':x-no-pass'));
                            }
                        },
                        success: function (data, status, xhr) {
                            // Re-enable button
                            button.removeAttr('disabled');
                            active = false;

                            // Run user-defined callback
                            if (typeof options.success === 'function') {
                                options.success(data, status, xhr);
                            }
                        },
                        error: function (data, status, xhr) {
                            // Re-enable button
                            button.removeAttr('disabled');
                            active = false;

                            // Run user-defined callback
                            if (typeof options.error === 'function') {
                                options.error(data, status, xhr);
                            }
                        },
                        data: options.data || dataFromFormElements
                    });
                });
            });
        }
    });
}(jQuery));

/*jslint sloppy: true, unparam: true, todo: true, nomen: true */
/*global alert: false, jQuery: false, CMM_API_CONFIG: false, Base64: false, JST: false, _: false */

(function ($) {
    // String.trim() polyfill
    if (!String.prototype.trim) {
        String.prototype.trim = function () {
            return this.replace(/^\s+|\s+$/gm, '');
        };
    }

    /**
     * @constructor
     */
    var CmmDashboard = function (options) {
        // Ensure 'this' -> 'CmmDashboard' in all these methods
        _.bindAll(this, 'load', 'sort', 'filter', 'render', 'paginate', 'search', 'selectFolder', 'order', 'bindEvents', 'unbindEvents');

        this.elem = options.elem;   // jQuery object to draw into
        this.url = options.url;
        this.defaultUrl = options.apiUrl + '/requests?v=' + options.version;
        this.tokenIds = options.tokenIds || [];
        this.apiId = options.apiId || '';

        this.currentPage = 0;
        this.perPage = 10;

        this.currentFolder = 'All';
        this.folders = options.folders || {
            'All': { workflow_statuses: ["New", "Shared", "Shared \\ Accessed Online", "Appealed", "Sent to Plan"], data: [] },
            'New': { workflow_statuses: ["New", "Shared", "Shared \\ Accessed Online"], data: [] },
            'Open': { workflow_statuses: ["Appealed", "Sent to Plan"], data: [] }
        };

        this.currentOrder = 'desc';

        if (options.data === undefined) {
            this.load(_.bind(function () {
                this.sort();
                this.filter();
                this.render();
            }, this));
        } else {
            this.data = options.data;
            this.sort();
            this.filter();
            this.render();
        }
    };

    /**
     * @description Load data for dashboard to display
     */
    CmmDashboard.prototype.load = function (callback) {
        var self = this;

        this.elem.html('<h3>Loading...</h3>');

        $.ajax({
            url: this.url || this.defaultUrl,
            type: 'GET',
            data: {
                token_ids: this.tokenIds
            },
            beforeSend: function (xhr, settings) {
                if (self.url === undefined) {
                    xhr.setRequestHeader('Authorization', 'Bearer ' + self.apiId + '+');
                }
            },
            success: function (data, status, xhr) {
                self.data = data.requests;

                if (typeof callback === 'function') {
                    callback();
                }
            },
            error: function (data, status, xhr) {
                self.elem.empty().text('There was an error processing your request. Please try again.');
            }
        });
    };

    /**
     * @description Sort by "created_at" timestamp - newer first
     */
    CmmDashboard.prototype.sort = function () {
        var self = this;

        this.data.sort(function sortByDate(a, b) {
            if (a.created_at === b.created_at) {
                return 0;
            }

            return a.created_at < b.created_at ? 1 : -1;
        });

        _.each(this.data, function sortIntoFolders(request) {
            _.each(self.folders, function (folder, name) {
                if (folder.workflow_statuses.indexOf(request.workflow_status) !== -1) {
                    folder.data.push(request);
                }
            });
        });
    };

    /**
     * @description Filter data based on search input
     */
    CmmDashboard.prototype.filter = function (clear) {
        var data,
            request,
            i,
            j;

        data = this.folders[this.currentFolder].data;

        // Clear out previous filtered values
        this.filteredData = [];
        this.searchQuery = $('input[name=q]').val() || '';
        this.searchQuery = this.searchQuery.trim().toLowerCase();

        // Just use default data if no search query
        if (this.searchQuery === '') {
            this.filteredData = data;
            return;
        }

        for (i = 0, j = data.length; i < j; i += 1) {
            request = data[i];

            // determine if request matches any of the searchable fields - first/last name, dob, drug name, or PA key (id)
            // Only add the request one time if there's any kind of match
            if (request.patient.first_name.toLowerCase().indexOf(this.searchQuery) !== -1) {
                this.filteredData.push(request);
            } else if (request.patient.last_name.toLowerCase().indexOf(this.searchQuery) !== -1) {
                this.filteredData.push(request);
            } else if (request.patient.date_of_birth.toLowerCase().indexOf(this.searchQuery) !== -1) {
                this.filteredData.push(request);
            } else if (request.prescription.name && request.prescription.name.toLowerCase().indexOf(this.searchQuery) !== -1) {
                this.filteredData.push(request);
            } else if (request.id.toLowerCase().indexOf(this.searchQuery) !== -1) {
                this.filteredData.push(request);
            }
        }
    };

    /**
     * @description Write main template to DOM
     */
    CmmDashboard.prototype.render = function () {
        // Render main template to DOM
        this.elem.html(JST.dashboard({ folders: this.folders, currentFolder: this.currentFolder }));

        // Display content
        this.displayContent();

        this.bindEvents();
    };

    /**
     * @description Set up event handlers
     */
    CmmDashboard.prototype.bindEvents = function () {
        // Handle pagination
        $('.pagination a', this.elem).on('click', this.paginate);

        // Handle searching
        $('input.search', this.elem).on('keyup', _.debounce(this.search, 500));
        $('button.clear', this.elem).on('click', this.search);

        // Handle folder selection
        $('.folders a', this.elem).on('click', this.selectFolder);

        // Handle date ordering
        $('.order button', this.elem).on('click', this.order);
    };

    /**
     * @description Remove event handlers
     */
    CmmDashboard.prototype.unbindEvents = function () {
        // Handle pagination
        $('.pagination a', this.elem).off('click', this.paginate);

        // Handle searching
        $('input.search', this.elem).off('keyup', _.debounce(this.search, 500));
        $('button.clear', this.elem).off('click', this.search);

        // Handle folder selection
        $('.folders a', this.elem).off('click', this.selectFolder);

        // Handle date ordering
        $('.order button', this.elem).off('click', this.order);
    };

    /*
     * @description Reverse sort order of requests
     */
    CmmDashboard.prototype.order = function (event) {
        var button = $(event.target);

        if (this.currentOrder !== button.data('direction')) {
            button.addClass('active').parent('div').siblings('div').children('button').removeClass('active');
            this.currentOrder = button.data('direction');
            _.each(this.folders, function (folder) {
                folder.data.reverse();
            });
            this.displayContent();
        }
    };

    /**
     * @description Handle changing sub-folders of requests
     */
    CmmDashboard.prototype.selectFolder = function (event) {
        var folder = $(event.target);

        event.preventDefault();

        $('.folders li', this.elem).removeClass('active');
        folder.parent('li').addClass('active');
        this.currentFolder = folder.attr('href').substring(1);
        this.currentPage = 0;
        this.filter();
        this.displayContent();
    };

    /**
     * @description Handle search form input
     */
    CmmDashboard.prototype.search = function (event) {
        var target = $(event.target);
        event.preventDefault();

        if (target.hasClass('clear')) {
            $('input[name=q]', this.elem).val('');
        }

        this.currentPage = 0;
        this.filter();
        this.displayContent();
    };

    /**
     * @description Handle changing pages for request results
     */
    CmmDashboard.prototype.paginate = function (event) {
        var page,
            button;

        event.preventDefault();
        button = $(event.target);

        page = parseInt(button.attr('href'), 10);

        if (isNaN(page)) {
            return;
        }

        this.currentPage = page;
        this.displayContent();
    };

    /**
     * @description Write current page of requests to the DOM
     */
    CmmDashboard.prototype.displayContent = function () {
        var begin,
            end,
            totalPages;

        begin = this.currentPage * this.perPage;
        end = begin + this.perPage;
        totalPages = Math.ceil(this.filteredData.length / this.perPage) - 1; // 0-index based

        // Render to DOM
        $('.content', this.elem).html(JST.dashboardContent({ requests: this.filteredData.slice(begin, end), currentPage: this.currentPage, totalPages: totalPages }));
    };

    $.fn.extend({
        dashboard: function (options) {
            // Remove event handler created by this plugin
            if (options === 'destroy') {
                return this.each(function () {
                    var elem = $(this),
                        dashboard = elem.data('dashboard');

                    if (dashboard) {
                        dashboard.unbindEvents();
                    }

                    elem.remove();
                });
            }

            return this.each(function () {
                var elem = $(this);
                options = $.extend(options, { elem: elem });
                elem.data('dashboard', new CmmDashboard(options));
            });
        }
    });
}(jQuery));

(function($) {
  $.fn.showRequestPagesForm = function(options) {
    $.each(this, _.bind(function() {
      var requestPages   = new RequestPages(options);
      requestPages.container = this;
      requestPages.showForm();
    }, this));
    return this;
  };
}(jQuery));

window.RequestPages = function(options) {

  this.defaultSelector = '.request-pages';
  this.container       = $(this.defaultSelector);

  this.version = options.version || 1;
  this.apiId = options.apiId || '';
  this.tokenId = options.tokenId || '';
  this.requestId = options.requestId || '';

  this.resourceUrl = options.url || options.apiUrl + '/request-pages/' + this.requestId +
    '?v=' + this.version + '&api_id=' + this.apiId + '&token_id=' + this.tokenId;

  this._getSuccessCallback = _.bind(function(data) {
    this.form = new RequestPages.Form(data['request_page']['forms'], data['request_page']['data'], data['request_page']['actions']);
    $(this.container).html(this.form.render());
    $(this.container).find('form').on('submit', _.bind(function(e) {
      this.postForm();
      return false;
    }, this));

  }, this);

  this.showForm = _.bind(function() {
    $.get(this.resourceUrl, this._getSuccessCallback);

  }, this);

  this.postForm = _.bind(function() {
    $.post(
      this.resourceUrl,
      $(this.container).find('form').serialize(),
      this._getSuccessCallback );

  }, this);

};

window.RequestPages.Form = function(formsJson, currentValues, actions) {
  this.actionsJson   = actions;

  this.template = 'form';

  this.name = _.bind(function() {
    return Object.keys(formsJson)[0];

  }, this);

  this.formJson      = formsJson[this.name()];
  this.currentValues = currentValues[this.name()];

  this.questionSets = [];
  this.formJson['question_sets'].forEach(_.bind(function(questionSet) {
      this.questionSets.push(
        new RequestPages.QuestionSet(questionSet, this.currentValues)
      );

    }, this));

  this.actions = [];
  this.actionsJson.forEach(_.bind(function(action) {
    this.actions.push( new RequestPages.Form.Action(action) );

  }, this));

  this.find_question_by_id = _.bind(function(questionId) {
    var foundQuestion = {};
    this.questionSets.forEach(_.bind(function(questionSet) {
      questionSet.questions.forEach(_.bind(function(question) {
        if (question.questionId() === questionId) {
          return foundQuestion = question;
        }
      }, this));
    }, this));
    return foundQuestion;
  }, this);

  this.render = _.bind(function() {
    return JST[this.template]({ form: this });
  }, this);

};

window.RequestPages.Form.Action = function(actionJson) {
  this.ref    = actionJson[ 'ref'    ];
  this.title  = actionJson[ 'title'  ];
  this.href   = actionJson[ 'href'   ];
  this.method = actionJson[ 'method' ];

  this.template = 'action_button';

  this.slug = _.bind(function() {
    return this.title.toLowerCase().replace(/[\s\/]+/g, '_');
  }, this);

  this._addHandler = _.bind(function() {
    var btnSelector = 'button.' + this.slug();
    $('.request-pages').on('click', btnSelector, _.bind(function(e) {
      $('input.form_action').val(this.title);
    }, this));
  }, this);

  this.render = _.bind(function() {
    this._addHandler();
    return JST[this.template]({ action: this });
  }, this);
};

window.RequestPages.QuestionSet = function(questionSetJson, currentValues) {
  this.title = questionSetJson['title'];

  this.template = 'question_set';

  this.questions = [];
  questionSetJson['questions'].forEach(_.bind(function(questionJson) {
    var currentValue;
    currentValue = currentValues[questionJson['question_id']];
    return this.questions.push(RequestPages.Question.create(questionJson, currentValue));
  }, this));

  this.render = _.bind(function() {
    return JST[this.template]({ questionSet: this });
  }, this);

};

window.RequestPages.Question = function(questionJson, currentValue) {
  if (currentValue == null) {
    currentValue = '';
  }
  this.dna = questionJson;
  this.value = currentValue;

  this.template = 'unknown_question';

  this.questionType = _.bind(function() { return this.dna.question_type; }, this);
  this.questionText = _.bind(function() { return this.dna.question_text; }, this);
  this.questionId   = _.bind(function() { return this.dna.question_id;   }, this);
  this.helpText     = _.bind(function() { return this.dna.help_text;     }, this);
  this.defaultNextQuestionId =
    _.bind(function() { return this.dna.default_next_question_id; }, this);


  this.isRequired = _.bind(function() {
    if (this.dna.flag === 'REQUIRED') {
      return 'required';
    } else {
      return '';
    }
  }, this);

  this.render = _.bind(function() {
    return JST[this.template]({
      question: this
    });
  }, this);

};

window.RequestPages.Question.create = function(questionJson, currentValue) {
  if (currentValue == null) {
    currentValue = '';
  }

  var questionFactory = (function() {
    switch (questionJson['question_type']) {
      case 'FREE_TEXT':
        return RequestPages.Question.FreeText;
      case 'CHOICE':
        return RequestPages.Question.Choice;
      case 'DATE':
        return RequestPages.Question.Date;
      case 'NUMERIC':
        return RequestPages.Question.Numeric;
      case 'STATEMENT':
        return RequestPages.Question.Statement;
      case 'HIDDEN':
        return RequestPages.Question.Hidden;
      case 'FILE':
        return RequestPages.Question.File;
      case 'CHECKBOX':
        return RequestPages.Question.Checkbox;
      case 'FREE_AREA':
        return RequestPages.Question.FreeArea;
      default:
        return function(question) { return question; };
    }
  })();

  return questionFactory(new RequestPages.Question(questionJson, currentValue));

};

window.RequestPages.Question.init = function() {};

window.RequestPages.Question.Checkbox = function(question) {

  question.template = 'checkbox_question';

  return question;
};

window.RequestPages.Question.Choice = function(question) {

  question.template = 'choice_question';

  question.selectMultiple = _.bind(function() {
    if (this.dna.select_multiple) {
      return 'multiple';
    } else {
      return '';
    }
  }, question);

  question.choices = _.bind(function() {
    return this.dna.choices;
  }, question);

  question.isSelected = _.bind(function(choice) {
    if (choice.choice_id === this.value) {
      return 'selected';
    } else {
      return '';
    }
  }, question);

  return question;
};

window.RequestPages.Question.Date = function(question) {

  question.template = 'date_question';

  return question;
};

window.RequestPages.Question.File = function(question) {

  question.template = 'file_question';

  return question;
};

window.RequestPages.Question.FreeArea = function(question) {

  question.template = 'free_area_question';

  question.placeholder = _.bind(function() {
    return this.dna.placeholder;
  }, question);

  return question;
};

window.RequestPages.Question.FreeText = function(question) {

  question.template = 'free_text_question';

  question.placeholder = _.bind(function() {
    return this.dna.placeholder;
  }, question);

  return question;
};

window.RequestPages.Question.Hidden = function(question) {

  question.template = 'hidden_question';

  return question;
};

window.RequestPages.Question.Numeric = function(question) {

  question.template = 'numeric_question';

  return question;
};

window.RequestPages.Question.Statement = function(question) {

  question.template = 'statement_question';

  question.content_plain = _.bind(function() {
    return this.dna.content_plain;
  }, question);

  question.content_html = _.bind(function() {
    return this.dna.content_html;
  }, question);

  return question;
};

/*jslint sloppy: true, unparam: true, todo: true, nomen: true */
/*global jQuery: false, _: false */
(function ($) {
    $.fn.extend({
        showHelp: function (options) {
            options = $.extend({}, options);

            return this.each(function () {
                var content = '<h1>For assistance using CoverMyMeds&reg;</h1>' +
                              '<ul>' +
                              '<li>Phone: 1-866-452-5017</li>' +
                              '<li>Email: <a href="mailto:help@covermymeds.com">help@covermymeds.com</a></li>' +
                              '</ul>' +
                              '<h1>Send forms or report data issues</h1>' +
                              '<ul>' +
                              '<li>Phone: 1-866-452-5017</li>' +
                              '<li>Fax: 1-615-379-2541</li>' +
                              '<li>Email: <a href="mailto:data@covermymeds.com">data@covermymeds.com</a></li>';
                              '</ul>';

                $(this).html(content);
            });
        }
    });
}(jQuery));


/**
 *
 *  Base64 encode / decode
 *  http://www.webtoolkit.info/
 *
 **/

var Base64 = {

    // private property
    _keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",

    // public method for encoding
    encode : function (input) {
        var output = "";
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        var i = 0;

        input = Base64._utf8_encode(input);

        while (i < input.length) {

            chr1 = input.charCodeAt(i++);
            chr2 = input.charCodeAt(i++);
            chr3 = input.charCodeAt(i++);

            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;

            if (isNaN(chr2)) {
                enc3 = enc4 = 64;
            } else if (isNaN(chr3)) {
                enc4 = 64;
            }

            output = output +
            this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
            this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);

        }

        return output;
    },

    // public method for decoding
    decode : function (input) {
        var output = "";
        var chr1, chr2, chr3;
        var enc1, enc2, enc3, enc4;
        var i = 0;

        input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

        while (i < input.length) {

            enc1 = this._keyStr.indexOf(input.charAt(i++));
            enc2 = this._keyStr.indexOf(input.charAt(i++));
            enc3 = this._keyStr.indexOf(input.charAt(i++));
            enc4 = this._keyStr.indexOf(input.charAt(i++));

            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;

            output = output + String.fromCharCode(chr1);

            if (enc3 != 64) {
                output = output + String.fromCharCode(chr2);
            }
            if (enc4 != 64) {
                output = output + String.fromCharCode(chr3);
            }

        }

        output = Base64._utf8_decode(output);

        return output;

    },

    // private method for UTF-8 encoding
    _utf8_encode : function (string) {
        string = string.replace(/\r\n/g,"\n");
        var utftext = "";

        for (var n = 0; n < string.length; n++) {

            var c = string.charCodeAt(n);

            if (c < 128) {
                utftext += String.fromCharCode(c);
            }
            else if((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            }
            else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }

        }

        return utftext;
    },

    // private method for UTF-8 decoding
    _utf8_decode : function (utftext) {
        var string = "";
        var i = 0;
        var c = c1 = c2 = 0;

        while ( i < utftext.length ) {

            c = utftext.charCodeAt(i);

            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            }
            else if((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i+1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            }
            else {
                c2 = utftext.charCodeAt(i+1);
                c3 = utftext.charCodeAt(i+2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            }

        }

        return string;
    }

}
