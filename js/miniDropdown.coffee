(($, window, undefined_) ->
  Naaav = ($el, options) ->
    @$el = $el
    @config = $.extend({}, $.fn.naaav.defaults, options or {})
    @_init()

  Naaav:: =
    _init: ->
      self = this
      @_setElems()
      hasEasingFunc = ($.isFunction($.easing[@config.easing]))
      @config.easing = "swing"  unless hasEasingFunc
      @animateMethod
      switch @config.animation
        when "fade"
          @animateMethod =
            show: "fadeIn"
            hide: "fadeOut"
        when "slide"
          @animateMethod =
            show: "slideDown"
            hide: "slideUp"
        else
          @animateMethod =
            show: "fadeIn"
            hide: "fadeOut"
      @$items.bind
        mouseenter: (e) ->
          $item = $(this)
          $subnav = self._getSubNav($item)
          fn = (if $.isFunction(self.config.showFunc) then self.config.showFunc else self._show)
          fn.apply self, [ $item, $subnav ]

        mouseleave: (e) ->
          $item = $(this)
          $subnav = self._getSubNav($item)
          fn = (if $.isFunction(self.config.hideFunc) then self.config.hideFunc else self._hide)
          fn.apply self, [ $item, $subnav ]

    _animate: ($subnav, type) ->
      $subnav.stop(false, true)[@animateMethod[type]] @config[type], @config.easing, ->
        $(this)[type]()

    _show: ($item, $subnav) ->
      self = this
      @hideAll $item
      $item.children("a").addClass @config.activeClass
      window.clearTimeout $item.data("timeoutId")
      $item.data "timeoutId", window.setTimeout(->
        self._animate $subnav, "show"
      , @config.delayIn)

    _hide: ($item, $subnav) ->
      self = this
      $item.children("a").removeClass @config.activeClass
      window.clearTimeout $item.data("timeoutId")
      $item.data "timeoutId", window.setTimeout(->
        self._animate $subnav, "hide"
      , @config.delayOut)

    _getSubNav: ($link) ->
      $link.children("ul").first()

    _setElems: ->
      @$items = @$el.children("li")
      @$links = @$items.children("a")
      @$subnavs = @$items.children("ul")

    hideAll: ($item) ->
      @$links.removeClass @config.activeClass
      @$subnavs.stop(false, true).hide()

  $.fn.naaav = (options) ->
    return this  unless @length
    args = (if (arguments[1]) then Array::slice.call(arguments, 1) else null)
    inst = undefined
    @each ->
      $elem = $(this)
      return  unless $elem.find("ul").length
      if typeof options is "string"
        inst = $elem.data("naaav")
        if inst[options]
          inst[options].apply inst, args
        else
          $.error "Method " + options + " does not exist on jQuery.naaav"
      else
        return this  if $elem.data("naaav")
        inst = new Naaav($elem, options)
        $elem.data "naaav", inst

    this

  $.fn.naaav.defaults =
    activeClass: "active"
    animation: "fade"
    easing: "swing"
    show: 100
    hide: 100
    delayIn: 100
    delayOut: 200
    showFunc: null
    hideFunc: null
) jQuery, window