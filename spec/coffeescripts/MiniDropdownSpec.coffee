describe 'miniDropdown', ->
  options =
    activeClass: 'active'
    animation: 'fade'


  beforeEach ->
    loadFixtures 'fragment.html'
    @$element       = $('.dropdown')
    @$firstListItem = @$element.children('li').first()
    @$firstSubNav   = @$firstListItem.children('ul').first()
    @clock          = sinon.useFakeTimers()

  it 'should be available on the jQuery object', ->
    expect($.fn.miniDropdown).toBeDefined()

  it 'should be chainable', ->
    expect(@$element.miniDropdown(options)).toBe(@$element)

  it 'should offers default values', ->
    plugin = new $.miniDropdown(@$element[0], options)

    expect(plugin.defaults).toBeDefined()

  it 'should overwrites the settings', ->
    plugin = new $.miniDropdown(@$element[0], options)

    expect(plugin.settings.activeClass).toBe(options.activeClass)
    expect(plugin.settings.animation).toBe(options.animation)

  describe 'activeClass', ->
    it 'should set the default active css class when mouseenter on the list item', ->
      new $.miniDropdown(@$element)
      @$firstListItem.trigger('mouseenter')

      expect(@$firstListItem.children('a.active').first()).toExist()

    it 'should set a custom active css class when mouseenter on the list item', ->
      new $.miniDropdown(@$element, {activeClass: 'custom-css-class'})
      @$firstListItem.trigger('mouseenter')

      expect(@$firstListItem.children('a.custom-css-class').first()).toExist()

    it 'should remove active class on mouseleave', ->
      new $.miniDropdown(@$element)
      @$firstListItem.trigger('mouseenter')
      @clock.tick(10)
      @$firstListItem.trigger('mouseleave')
      @clock.tick(10)

      expect(@$firstListItem.children('a.active').first()).not.toExist()

  describe 'toggle', ->
    it 'should toggle the sub nav on mouseenter and hide it on mouseleave', ->
      new $.miniDropdown(@$element)
      @$firstListItem.trigger('mouseenter')

      @clock.tick(10)
      expect(@$firstSubNav).toBeVisible()     

      @$firstListItem.trigger('mouseleave')

      @clock.tick(10)
      expect(@$firstSubNav).toBeHidden()

    it 'should hide all the sub navs before showing one', ->
      new $.miniDropdown(@$element)
      $secondSubNav = @$element.find('ul.about').first()
      $secondSubNav.show()
      expect($secondSubNav).toBeVisible()     

      @$firstListItem.trigger('mouseenter')

      @clock.tick(10)
      expect($secondSubNav).toBeHidden()     


  describe 'delay', ->
    it 'should only show the sub nav only after the delay', ->
      new $.miniDropdown(@$element, delayIn: 100)
      @$firstListItem.trigger('mouseenter')

      expect(@$firstSubNav).toBeHidden()

      @$firstListItem.trigger('mouseleave')
      @clock.tick(100)
      expect(@$firstSubNav).toBeHidden()

      @$firstListItem.trigger('mouseenter')
      @clock.tick(100)
      expect(@$firstSubNav).toBeVisible()

    it 'should only hide the sub nav only after the delay', ->
      new $.miniDropdown(@$element, delayOut: 100)
      @$firstListItem.trigger('mouseenter')

      @clock.tick(10)
      expect(@$firstSubNav).toBeVisible()

      @$firstListItem.trigger('mouseleave')
      expect(@$firstSubNav).toBeVisible()

      @clock.tick(100)
      expect(@$firstSubNav).toBeHidden()

  describe 'callbacks', ->
    beforeEach ->
      @foo = jasmine.createSpy('foo')

    it 'should call showFunction on show when defined', ->
      new $.miniDropdown(@$element, showFunction: @foo)
      @$firstListItem.trigger('mouseenter')
      @clock.tick(10)

      expect(@foo).toHaveBeenCalledWith(jasmine.any(Object), jasmine.any(Object))

    it 'should call hideFunction on hide when defined', ->
      new $.miniDropdown(@$element, hideFunction: @foo)
      @$firstListItem.trigger('mouseleave')
      @clock.tick(10)

      expect(@foo).toHaveBeenCalledWith(jasmine.any(Object), jasmine.any(Object))
      




