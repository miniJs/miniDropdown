/*
    # jQuery naaav
    A Homebrand Dropdown Menu Plugin

    Just _another_ jQuery drop-down menu plugin :)

    This one is a **super** basic one that's intended to just streamline the
    setting up of a drop-down navigation. It sets up event listeners and handlers,
    along with the in/out delays around a sub-menu's show/hide effect.

    You can pass in your own show/hide functions to completely customise the
    sub-menu display behaviour.

    Created by Victor Nguyen
    @victornguyen
*/

(function($,window,undefined){
    
    var Naaav = function($el, options) {
        this.$el     = $el;
        this.config  = $.extend({}, $.fn.naaav.defaults, options || {});
        this._init();
    };

    Naaav.prototype = {

        _init: function() {
            var self = this;
            
            // store references to key elements
            this._setElems();

            // check if easing func is available and fallback
            var hasEasingFunc = ($.isFunction($.easing[this.config.easing]));
            if (!hasEasingFunc) this.config.easing = "swing";
            
            // set animation method
            this.animateMethod;
            switch (this.config.animation) {
                case 'fade':
                    this.animateMethod = {
                        show: 'fadeIn',
                        hide: 'fadeOut'
                    };
                    break;
                case 'slide':
                    this.animateMethod = {
                        show: 'slideDown',
                        hide: 'slideUp'
                    };
                    break;
                default:
                    this.animateMethod = {
                        show: 'fadeIn',
                        hide: 'fadeOut'
                    };
            }
            
            // bind event handlers
            this.$items.bind({
                'mouseenter': function(e){
                    var $item   = $(this),
                        $subnav = self._getSubNav($item),
                        fn      = $.isFunction(self.config.showFunc) ? self.config.showFunc : self._show;
                    fn.apply(self, [ $item, $subnav ]);
                },
                'mouseleave': function(e){
                    var $item   = $(this),
                        $subnav = self._getSubNav($item),
                        fn      = $.isFunction(self.config.hideFunc) ? self.config.hideFunc : self._hide;
                    fn.apply(self, [ $item, $subnav ]);
                }
            });      
        },
        
        _animate: function($subnav, type) {
            $subnav
                .stop(false, true)
                [this.animateMethod[type]](
                    this.config[type],
                    this.config.easing,
                    function(){
                        $(this)[type]();
                    }
                );
        },
        
        _show: function($item, $subnav) {
            var self = this;
            this.hideAll($item);
            $item.children('a').addClass(this.config.activeClass);
            window.clearTimeout($item.data('timeoutId'));
            $item.data(
                'timeoutId',
                window.setTimeout(
                    function(){
                        self._animate($subnav, 'show');
                    },
                    this.config.delayIn
                )
            );
        },
        
        _hide: function($item, $subnav) {
            var self = this;
            $item.children('a').removeClass(this.config.activeClass);
            window.clearTimeout($item.data('timeoutId'));
            // storing timeout id against the item to clear in _show() later...
            // prevents multiple delayed animations from queing up
            $item.data(
                'timeoutId',
                window.setTimeout(
                    function(){
                        self._animate($subnav, 'hide');
                    },
                    this.config.delayOut
                )
            );
        },

        _getSubNav: function($link) {
            return $link.children('ul').first();
        },

        _setElems: function() {
            this.$items   = this.$el.children('li');
            this.$links   = this.$items.children('a');
            this.$subnavs = this.$items.children('ul');
        },

        hideAll: function($item) {
            this.$links.removeClass(this.config.activeClass);
            this.$subnavs.stop(false, true).hide();
        }
        
    };
    
    $.fn.naaav = function(options) {
        // return if no elements found
        if (!this.length) return this;
        
        var args = (arguments[1]) ? Array.prototype.slice.call(arguments,1) : null,
            inst;

        this.each(function(){
            var $elem = $(this);
            if (!$elem.find('ul').length) return;
            if (typeof options === 'string') {
                inst = $elem.data('naaav');
                if (inst[options])
                    return inst[options].apply(inst,args);
                else
                    $.error('Method '+options+' does not exist on jQuery.naaav');
            }
            else {
                // create and store instance in data of $elem
                if ($elem.data('naaav')) return this;
                inst = new Naaav($elem, options);
                $elem.data('naaav', inst);
            }
        });

        return this;
    };
    
    $.fn.naaav.defaults = {
        activeClass:    'active',
        animation:      'fade',    // 'slide' or 'fade'
        easing:         'swing',
        show:           100,
        hide:           100,
        delayIn:        100,
        delayOut:       200,
        showFunc:       null,       // specify your own show/hide
        hideFunc:       null        // submenu functions...
    };

}(jQuery,window));