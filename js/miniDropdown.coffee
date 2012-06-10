#
# miniDropdown, a dropdown plugin for jQuery
# Instructions: coming soon...
# By: Matthieu Aussaguel, http://www.mynameismatthieu.com, @mattaussaguel
# Version: v0.1 Beta
# Updated: June 10, 2012
# More info: http://minijs.com/
#

$ ->
  $.miniDropdown = (element, options) ->
    @defaults = 
      activeClass:  "active" # css class added to the ul active element
      animation:    "basic"  # dropdown animation: 'basic' | 'fade' | 'slide'
      easing:       "swing"  # easing equation used during the animation
      show:         0        # show animation duration in milliseconds
      hide:         0        # hide animation duration in milliseconds
      delayIn:      0        # delay duration on show in milliseconds
      delayOut:     0        # delay duration on hide in milliseconds
      showFunction: null     # custom show function
      hideFuntion:  null     # custom hide function

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
    # Helper methods

    getSubNav = ($item) => $item.children("ul").first()

    setState = (@state) ->

    checkEasingFunction = => @settings.easing = "swing"  unless $.isFunction($.easing[@settings.easing])

    ## Animation
    toggle = (type, $item) =>
      $subnav = getSubNav($item)
      window.clearTimeout $item.data("timeoutId")

      if type is 'show'
        fn    = if $.isFunction(@settings.showFunction) then @settings.showFunction else show
        delay = @settings.delayIn

        hideAll $item
        $item.children("a").addClass(@settings.activeClass)
      else
        fn    = if $.isFunction(@settings.hideFunction) then @settings.hideFunction else hide
        delay = @settings.delayOut

        $item.children("a").removeClass(@settings.activeClass)

      $item.data "timeoutId", window.setTimeout(=>
        fn.apply this, [ $item, $subnav ]
      , delay)  

    bindEvents = =>
      @$items.bind
        mouseenter: (e) => toggle('show', $(e.currentTarget))
        mouseleave: (e) => toggle('hide', $(e.currentTarget))

    animate = ($subnav, type) =>
      $subnav.stop(false, true) 
      method = animateMethods[@settings.animation][type]
      $subnav[method](@settings[type], @settings.easing, ->
        $(this)[type]()
      )

    show = ($item, $subnav) => animate $subnav, "show"

    hide = ($item, $subnav) => animate $subnav, "hide"

    hideAll = ($item) =>
      @$links.removeClass @settings.activeClass
      @$subnavs.stop(false, true).hide()

    # Public Methods
    #get current state
    @getState = -> state

    # get particular plugin setting
    @getSetting = (settingKey) ->
      @settings[settingKey]

    # call one of the plugin setting functions
    @callSettingFunction = (functionName) ->
      @settings[functionName]()

    @init = ->
      setState 'loading'
      @settings = $.extend {}, @defaults, options
      @$items   = @$element.children("li")
      @$links   = @$items.children("a")
      @$subnavs = @$items.children("ul")
      
      checkEasingFunction()
      bindEvents()
      setState 'loaded'

    @init()

  $.fn.miniDropdown = (options) ->
    return this.each ->
      if undefined == ($ this).data('miniDropdown')
        miniDropdown = new $.miniDropdown this, options
        ($ this).data 'miniDropdown', miniDropdown