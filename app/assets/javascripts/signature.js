(function($) {
  $.widget("CoverMyMeds.signaturePad", {
    options: {
    penColor: "#008", // blue
    penWidth: 1,
    canvasSize: {height: 68, width: 386},
    signaturePadClass: "signature-pad",
    canvasElement: "<canvas/>",
    signatureResetClass: "signature-pad-reset",
    resetElement: "<a href='#'>reset</a>",
  },

  _create: function(){
    this.signatureInput = $(this.element)
    this.penstate       = false  // is the pen down?
    this.pos            = null   // {x: int, y: int} last pen position
    this.context        = null   // canvas / vml context
    this.signaturePad   = null   // canvas element
    this.stream         = []     // collection of penstrokes to submit

    this._addReset()
    this._replaceInputWithCanvas()
    this._registerHanders()
    this._setupCanvas()
  },

  _replaceInputWithCanvas: function(){
    this.signatureInput.hide()
    this.signaturePad = $(this.options.canvasElement)
    this.signaturePad.attr("class", this.options.signaturePadClass)
    this.signaturePad.attr("height", this.options.canvasSize.height)
    this.signaturePad.attr("width", this.options.canvasSize.width)

    this.signatureInput.after(this.signaturePad)
  },

  _addReset: function(){
    var widget = this
    var reset = $(this.options.resetElement)
    reset.attr("class", this.options.signatureResetClass)
    this.signatureInput.after(reset)
    reset.on("click", function(event){
      event.preventDefault()
      widget.clearSignature()
    })
  },

  _registerHanders: function(){
    var signatureSelector = this.options.signatureSelector

    this.signaturePad.on("mousedown", $.proxy(this._penDown, this))
    this.signaturePad.on("touchstart", $.proxy(this._penDown, this))
    this.signaturePad.on("mousemove", $.proxy(this._penMove, this))
    this.signaturePad.on("touchmove", $.proxy(this._penMove, this))
    this.signaturePad.on("mouseup", $.proxy(this._penUp, this))
    this.signaturePad.on("touchend", $.proxy(this._penUp, this))
  },

  _setupCanvas: function(){
    var signaturePad = this.signaturePad.get(0)

    if (typeof G_vmlCanvasManager != "undefined") {
      signaturePad = G_vmlCanvasManager.initElement(signaturePad)
    }

    this.context = signaturePad.getContext("2d")

    this.context.strokeStyle = this.options.penColor
    this.context.lineWidth = this.options.penWidth
  },

  _savePenStroke: function(isNewStroke){
    this.stream.push([isNewStroke, this.pos.x, this.pos.y])
  },

  _penDown: function(event){
    this.penstate = true
    this.pos = this._newEvent(event).penPosition()
    this.context.beginPath()
    this.context.moveTo(this.pos.x, this.pos.y)
    this._savePenStroke(this._continueStroke)

    return false  // return false to prevent IE selecting the image
  },

  _penMove: function(event){
    var newPos = this._newEvent(event).penPosition()

    if(this.penstate){
      this.pos = newPos
      this.context.lineTo(newPos.x, newPos.y)
      this.context.stroke()
      this._savePenStroke(this._continueStroke)
    } else {
      this.context.moveTo(newPos.x, newPos.y)
    }

    return false
  },

  _penUp: function(){
    this.penstate = false
    this.signatureInput.val(this.toString())
    return false
  },

  _newEvent: function(event){
    var widget = this
    return {
      crossPlatform: function(){
        // mobile safari
        if(event.originalEvent && event.originalEvent.touches){
          return event.originalEvent.touches[0]
        }
        return event
      }(),
      penPosition: function(){
        var offset = widget.signaturePad.offset()
        var x = this.crossPlatform.pageX - offset.left
        var y = this.crossPlatform.pageY - offset.top

        return {x: x, y: y}
      }
    }
  },

  _newStroke: 1,
  _continueStroke: 0,

  toString: function(){
    return JSON.stringify(this.stream)
  },

  clearSignature: function(){
    this.context.clearRect(0, 0, 500, 500)
    this.stream = []
    this.signatureInput.val("")
  }

  })

}(jQuery));
