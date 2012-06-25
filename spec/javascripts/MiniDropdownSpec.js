(function() {

  describe('miniDropdown', function() {
    var options;
    options = {
      activeClass: 'active'
    };
    beforeEach(function() {
      loadFixtures('fragment.html');
      return this.$element = $('#fixtures');
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
    return it('should overwrites the settings', function() {
      var plugin;
      plugin = new $.miniDropdown(this.$element[0], options);
      return expect(plugin.settings.activeClass).toBe(options.activeClass);
    });
  });

}).call(this);
