
describe('miniDropdown', function() {
  var options;
  options = {
    activeClass: 'active',
    animation: 'fade'
  };
  beforeEach(function() {
    loadFixtures('fragment.html');
    this.$element = $('.dropdown');
    this.$firstListItem = this.$element.children('li').first();
    this.$firstSubNav = this.$firstListItem.children('ul').first();
    return this.clock = sinon.useFakeTimers();
  });
  it('should be available on the jQuery object', function() {
    return expect($.fn.miniDropdown).toBeDefined();
  });
  it('should be chainable', function() {
    return expect(this.$element.miniDropdown(options)).toBe(this.$element);
  });
  it('should offers default values', function() {
    var plugin;
    plugin = new $.miniDropdown(this.$element[0], options);
    return expect(plugin.defaults).toBeDefined();
  });
  it('should overwrites the settings', function() {
    var plugin;
    plugin = new $.miniDropdown(this.$element[0], options);
    expect(plugin.settings.activeClass).toBe(options.activeClass);
    return expect(plugin.settings.animation).toBe(options.animation);
  });
  describe('activeClass', function() {
    it('should set the default active css class when mouseenter on the list item', function() {
      new $.miniDropdown(this.$element);
      this.$firstListItem.trigger('mouseenter');
      return expect(this.$firstListItem.children('a.active').first()).toExist();
    });
    it('should set a custom active css class when mouseenter on the list item', function() {
      new $.miniDropdown(this.$element, {
        activeClass: 'custom-css-class'
      });
      this.$firstListItem.trigger('mouseenter');
      return expect(this.$firstListItem.children('a.custom-css-class').first()).toExist();
    });
    return it('should remove active class on mouseleave', function() {
      new $.miniDropdown(this.$element);
      this.$firstListItem.trigger('mouseenter');
      this.clock.tick(10);
      this.$firstListItem.trigger('mouseleave');
      this.clock.tick(10);
      return expect(this.$firstListItem.children('a.active').first()).not.toExist();
    });
  });
  describe('toggle', function() {
    it('should toggle the sub nav on mouseenter and hide it on mouseleave', function() {
      new $.miniDropdown(this.$element);
      this.$firstListItem.trigger('mouseenter');
      this.clock.tick(10);
      expect(this.$firstSubNav).toBeVisible();
      this.$firstListItem.trigger('mouseleave');
      this.clock.tick(10);
      return expect(this.$firstSubNav).toBeHidden();
    });
    return it('should hide all the sub navs before showing one', function() {
      var $secondSubNav;
      new $.miniDropdown(this.$element);
      $secondSubNav = this.$element.find('ul.about').first();
      $secondSubNav.show();
      expect($secondSubNav).toBeVisible();
      this.$firstListItem.trigger('mouseenter');
      this.clock.tick(10);
      return expect($secondSubNav).toBeHidden();
    });
  });
  describe('delay', function() {
    it('should only show the sub nav only after the delay', function() {
      new $.miniDropdown(this.$element, {
        delayIn: 100
      });
      this.$firstListItem.trigger('mouseenter');
      expect(this.$firstSubNav).toBeHidden();
      this.$firstListItem.trigger('mouseleave');
      this.clock.tick(100);
      expect(this.$firstSubNav).toBeHidden();
      this.$firstListItem.trigger('mouseenter');
      this.clock.tick(100);
      return expect(this.$firstSubNav).toBeVisible();
    });
    return it('should only hide the sub nav only after the delay', function() {
      new $.miniDropdown(this.$element, {
        delayOut: 100
      });
      this.$firstListItem.trigger('mouseenter');
      this.clock.tick(10);
      expect(this.$firstSubNav).toBeVisible();
      this.$firstListItem.trigger('mouseleave');
      expect(this.$firstSubNav).toBeVisible();
      this.clock.tick(100);
      return expect(this.$firstSubNav).toBeHidden();
    });
  });
  return describe('callbacks', function() {
    beforeEach(function() {
      return this.foo = jasmine.createSpy('foo');
    });
    it('should call showFunction on show when defined', function() {
      new $.miniDropdown(this.$element, {
        showFunction: this.foo
      });
      this.$firstListItem.trigger('mouseenter');
      this.clock.tick(10);
      return expect(this.foo).toHaveBeenCalledWith(jasmine.any(Object), jasmine.any(Object));
    });
    return it('should call hideFunction on hide when defined', function() {
      new $.miniDropdown(this.$element, {
        hideFunction: this.foo
      });
      this.$firstListItem.trigger('mouseleave');
      this.clock.tick(10);
      return expect(this.foo).toHaveBeenCalledWith(jasmine.any(Object), jasmine.any(Object));
    });
  });
});
