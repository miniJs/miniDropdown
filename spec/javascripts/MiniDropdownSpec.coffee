describe 'miniDropdown', ->
  options =
    activeClass: 'active'

  beforeEach ->
    loadFixtures 'fragment.html'
    @$element = $('#fixtures')

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