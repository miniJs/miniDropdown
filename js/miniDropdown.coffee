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
      animation:   "basic"
      easing:      "swing"
      show:        0
      hide:        0
      delayIn:     0
      delayOut:    0
      showFunc:    null
      hideFunc:    null

    animateMethods =
      basic:
        show: "show"
        hide: "hide"
      fade:
        show: "fadeIn"
        hide: "fadeOut"
      slide:
        show: "slideDown"
        hide: "slideUp"

    # current state
    @state = ''

    # plugin settings
    @settings = {}

    # jQuery version of DOM element attached to the plugin
    @$element = $ element

    # Private methods
    animate = ($subnav, type) =>
      $subnav.stop(false, true) 
      $subnav[animateMethods[@settings.animation][type]](@settings[type], @settings.easing, ->
        $(this)[type]()
      )

    show = ($item, $subnav) =>
      hideAll $item
      $item.children("a").addClass(@settings.activeClass)
      window.clearTimeout $item.data("timeoutId")
      console.log(@settings.delayIn)
      $item.data "timeoutId", window.setTimeout(=>
        animate $subnav, "show"
      , @settings.delayIn)

    hide = ($item, $subnav) =>
      $item.children("a").removeClass(@settings.activeClass)
      window.clearTimeout $item.data("timeoutId")
      $item.data "timeoutId", window.setTimeout(=>
        animate $subnav, "hide"
      , @settings.delayOut)

    getSubNav = ($link) => $link.children("ul").first()

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

      @$items   = @$element.children("li")
      @$links   = @$items.children("a")
      @$subnavs = @$items.children("ul")

      hasEasingFunc = ($.isFunction($.easing[@settings.easing]))
      @settings.easing = "swing"  unless hasEasingFunc

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