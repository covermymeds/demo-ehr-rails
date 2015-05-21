$.widget("CoverMyMeds.questionVisibility", {
  options: {
    data_next:          "data-next-question-id",
    data_default_next:  "data-default-next-id",
    name:               "name",
    last:               "END",
    effectedSelector:   ".row.question",
    questionSelector:   ".question [name]",
    hideBy:             function(row){ row.slideUp() },
    showBy:             function(row){ row.slideDown() },
  },

  _create: function(){
    this.$element = $(this.element)
    this.changed(this._allQuestions().first())
  },

  changed: function($changed){
    this._visibilityTree($changed)
  },

  // walks the tree of question-ids and hides all that should be hidden.
  _visibilityTree: function($startAt){
    var widget       = this
    var $keepVisible = widget._answeredQuestions($startAt).add($startAt)
    var nextIds      = widget._nextQuestionIds($startAt)
    $.each(nextIds, function(_, nextId){
      $next        = widget._question(nextId)
      $keepVisible = $keepVisible.add($next)
    })
    var $toHide = widget._allQuestions().not($keepVisible)

    _.each($toHide, function(e,i,l) {
      $(e).removeAttr('required');
      $(e).removeAttr('data-required');
      $(e).data('was-req', true)
    });

    _.each($keepVisible, function(e,i,l) {
      if ($(e).data('was-req') == true) {
        $(e).attr('required','');
        $(e).attr('data-required','');
      }
    });
    widget.options.showBy($keepVisible.closest(widget.options.effectedSelector))
    widget.options.hideBy($toHide.closest(widget.options.effectedSelector))
  },

  _answeredQuestions: function($changed){
    var widget             = this
    var $firstQuestion     = this._allQuestions().first()
    var changedId          = widget._questionId($changed)
    var $answeredQuestions = $("")

    var __answeredQuestions = function($question){
      $answeredQuestions = $answeredQuestions.add($question)
      var nextIds = widget._nextQuestionIds($question)
      $.each(nextIds, function(_, nextId){
        var didEnd = nextId == widget.options.last
        if(!didEnd) {
          __answeredQuestions(widget._question(nextId))
        }
      })
    }
    __answeredQuestions($firstQuestion)

    return $answeredQuestions
  },

  _allQuestions: function(){
    return this.$element.find(this.options.questionSelector)
   },

  _nextQuestionIds: function($question){
    var widget   = this
    var selected = $question.find(":selected")
    var checked  = $question.filter(":checked")
    if(selected.size()){
      var selectedNext = selected.attr(widget.options.data_next)
      var defaultNext  = widget._defaultNextQuestionId($question)
      return [selectedNext || defaultNext]
    }

    if(checked.size()){
      var defaultNext = widget._defaultNextQuestionId($question)
      var checkedNext = checked.map(function() {
        return $(this).attr(widget.options.data_next)
      })
      return $.merge([defaultNext], checkedNext)
    }

    else { return [widget._defaultNextQuestionId($question)] }
  },

  _defaultNextQuestionId: function($question){
    return $question.not("input[type=hidden]").attr(this.options.data_default_next)
  },

  _question: function(id){
    return this.$element.find("["+this.options.name+"='"+id+"']")
  },

  _questionId: function($question){
    return $question.attr(this.options.name)
  },

})
