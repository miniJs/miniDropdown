#
# miniDropdown, a dropdown plugin for jQuery
# Instructions: coming soon...
# By: Matthieu Aussaguel, http://www.mynameismatthieu.com, @mattaussaguel
# Version: coming soon...
# Updated: June 10, 2012
# More info: http://minijs.com/
#

$ ->
  $.miniDropdown = (element, options) ->
    @defaults = 
      activeClass: "active"
      animation:   "slide"
      easing:      "swing"
      show:        100
      hide:        100
      delayIn:     100
      delayOut:    200
      showFunc:    null
      hideFunc:    null

    # current state
    @state = ''

    # plugin settings
    @settings = {}

    # jQuery version of DOM element attached to the plugin
    @$element = $ element

    # Private methods
    animate = ($subnav, type) =>
      $subnav.stop(false, true)[@animateMethod[type]] @settings[type], @settings.easing, ->
        $(this)[type]()

    show = ($item, $subnav) =>
      hideAll $item
      $item.children("a").addClass(@settings.activeClass)
      window.clearTimeout $item.data("timeoutId")
      $item.data "timeoutId", window.setTimeout(=>
        animate $subnav, "show"
      , @settings.delayIn)

    hide = ($item, $subnav) =>
      $item.children("a").removeClass(@settings.activeClass)
      window.clearTimeout $item.data("timeoutId")
      $item.data "timeoutId", window.setTimeout(=>
        animate $subnav, "hide"
      , @settings.delayOut)

    getSubNav = ($link) =>
      $link.children("ul").first()

    setElems = =>
      @$items   = @$element.children("li")
      @$links   = @$items.children("a")
      @$subnavs = @$items.children("ul")

    hideAll = ($item) =>
      @$links.removeClass @settings.activeClass
      @$subnavs.stop(false, true).hide()

    # Public Methods
    # set current state
    setState = (@state) ->

    #get current state
    @getState = -> state

    # get particular plugin setting
    @getSetting = (settingKey) ->
      @settings[settingKey]

    # call one of the plugin setting functions
    @callSettingFunction = (functionName) ->
      @settings[functionName]()

    @init = ->
      @settings = $.extend {}, @defaults, options
      self = this
      setElems()

      hasEasingFunc = ($.isFunction($.easing[@settings.easing]))
      @settings.easing = "swing"  unless hasEasingFunc

      switch @settings.animation
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
            show: "show"
            hide: "hide"

      @$items.bind
        mouseenter: (e) =>
          $item = $ e.currentTarget
          $subnav = getSubNav($item)
          fn = (if $.isFunction(@settings.showFunc) then @settings.showFunc else show)
          fn.apply self, [ $item, $subnav ]

        mouseleave: (e) =>
          $item = $ e.currentTarget
          $subnav = getSubNav($item)
          fn = (if $.isFunction(@settings.hideFunc) then @settings.hideFunc else hide)
          fn.apply self, [ $item, $subnav ]

    @init()

  $.fn.miniDropdown = (options) ->
    return this.each ->
      if undefined == ($ this).data('miniDropdown')
        miniDropdown = new $.miniDropdown this, options
        ($ this).data 'miniDropdown', miniDropdown