shinyjqui = function() {

  //var interaction_func = ['draggable', 'droppable', 'resizable', 'selectable', 'sortable'];

  var getInputContainer = function(el) {
    var $container = $(el).closest(".shiny-input-container");
    if($container.length) {
      return $container.get(0);
    } else {
      return el;
    }
  };

  var regShinyInput = function(el, id, opt) {
    $.each(opt, function(suffix, callbacks){
      var input_name = id + '_' + suffix;
      $.each(callbacks, function(event_type, func){
        $(el).on(event_type, function(event, ui){
          var input_value = func(el, event, ui);
          Shiny.onInputChange(input_name, input_value);
        });
      });
    });
  };

  var handleShinyInput = function(el, opt, default_shiny_opt) {

    var id = shinyjqui.getId(el);

    if(id) {

      if(opt && opt.hasOwnProperty('shiny')) {
        // remove keys in default_shiny_opt that have duplicated input_suffix but with a input_handler.
        var suffix = Object.keys(default_shiny_opt);
        $.each(suffix, function(i, v){
          if($.inArray(v.replace(/:.+/, ''), Object.keys(opt.shiny)) >= 0) {
            delete default_shiny_opt[v];
          }
        });
        // overwrite default_shiny_opt with user provided opt.shiny
        $.extend(default_shiny_opt, opt.shiny);
        delete opt.shiny;
      }

      regShinyInput(el, id, default_shiny_opt);

    }

  };

  // ==============================================================================
  // The following code (splitWithEscape and evaluateStringMember) is obtained from htmlwidgets project
  // (https://github.com/ramnathv/htmlwidgets/blob/master/inst/www/htmlwidgets.js), which is licensed MIT.
  // The original license info:
  // YEAR: 2016
  // COPYRIGHT HOLDER: Ramnath Vaidyanathan, Joe Cheng, JJ Allaire, Yihui Xie, and Kenton Russell
  // ==============================================================================

  var splitWithEscape = function(value, splitChar, escapeChar) {
    var results = [];
    var escapeMode = false;
    var currentResult = "";
    for (var pos = 0; pos < value.length; pos++) {
      if (!escapeMode) {
        if (value[pos] === splitChar) {
          results.push(currentResult);
          currentResult = "";
        } else if (value[pos] === escapeChar) {
          escapeMode = true;
        } else {
          currentResult += value[pos];
        }
      } else {
        currentResult += value[pos];
        escapeMode = false;
      }
    }
    if (currentResult !== "") {
      results.push(currentResult);
    }
    return results;
  };

  var evaluateStringMember = function(o, member) {

    var parts = splitWithEscape(member, '.', '\\');
    for (var i = 0, l = parts.length; i < l; i++) {
      var part = parts[i];
      // part may be a character or 'numeric' member name
      if (o !== null && typeof o === "object" && part in o) {
        if (i == (l - 1)) { // if we are at the end of the line then evalulate
          if (typeof o[part] === "string")
            o[part] = eval("(" + o[part] + ")");
        } else { // otherwise continue to next embedded object
          o = o[part];
        }
      }
    }
  };


  var evalJS = function(data) {

    if (!(data['.evals'] instanceof Array)) data['.evals'] = [data['.evals']];
        for (var i = 0; data['.evals'] && i < data['.evals'].length; i++) {
          evaluateStringMember(data, data['.evals'][i]);
        }
    return data;

  };

  var interactions = {

    draggable : {

      enable : function(el, opt) {

        //el = getInputContainer(el);

        var func = function(el, event, ui) {
          return $(el).position();
        };

        var default_shiny_opt = {
          position : {
            dragcreate : func,
            drag : func
          }
        };

        handleShinyInput(el, opt, default_shiny_opt);

        $(el).draggable(opt);


      },

      disable : function(el) {

        el = getInputContainer(el);

        $(el).draggable('destroy');

      }

    },

    droppable : {

      enable : function(el, opt) {

        el = getInputContainer(el);

        var default_shiny_opt = {
          over : {
            dropcreate : function(el, event, ui){return [];},
            dropover : function(el, event, ui){return shinyjqui.getId(ui.draggable.get(0));}
          },
          dragging : {
            dropcreate : function(el, event, ui){return [];},
            dropactivate : function(el, event, ui){
            return shinyjqui.getId(ui.draggable.get(0));},
            dropdeactivate : function(el, event, ui){return [];}
          }
        };

        handleShinyInput(el, opt, default_shiny_opt);

        $(el).droppable(opt);


      },

      disable : function(el) {

        el = getInputContainer(el);

        $(el).droppable('destroy');

      }

    },

    resizable : {

      enable : function(el, opt) {

        if($(el).parent().hasClass('ui-resizable')) return;

        if(/action-button|html-widget-output|shiny-.+?-output/.test($(el).attr('class'))) {

          // Wrap the element when it is a shiny/htmlwidgets output, so that
          // the element's redraw on resizing won't remove the dragging handlers.
          // Shiny actionBUtton also needs wrapping. The resizable's internal
          // ui-wrapper is not working very well.
          var $wrapper = $('<div></div>')
            .outerWidth($(el).outerWidth() ? $(el).outerWidth() : '100%')
            .outerHeight($(el).outerHeight() ? $(el).outerHeight() : '100%')
            .addClass('jqui-resizable-wrapper');

          el = $(el)
            .wrap($wrapper)
            .outerWidth('100%')
            .outerHeight('100%')
            .parent().get(0);

        }

        var default_shiny_opt = {
          size : {
            resizecreate : function(el, event, ui){
              return {width: $(el).width(), height: $(el).height()};
            },
            resize : function(el, event, ui){
              return ui.size;
            }
          }
        };
        handleShinyInput(el, opt, default_shiny_opt);

        $(el).resizable(opt);

      },

      disable : function(el) {

        var $wrapper = $(el).parent('.ui-resizable');

        if($wrapper.length) {

          // do some more things when it is a shiny/htmlwidgets output.
          $wrapper.resizable('destroy');
          $(el)
            .outerWidth($wrapper.outerWidth())
            .outerHeight($wrapper.outerHeight())
            .insertAfter($wrapper);
          $wrapper.remove();

        } else {

          $(el).resizable('destroy');

        }

      }

    },

    selectable : {

      enable : function(el, opt) {

        var func = function(el, event, ui) {
          var $selected = $(el).children('.ui-selected');
          var html = $selected.map(function(i, e){return e.innerHTML;}).get();
          var ids = $selected.map(function(i, e){return shinyjqui.getId(e);}).get();
          return {'id': ids, 'html': html};
        };

        var default_shiny_opt = {
          'selected:shinyjqui.df' : {
            selectablecreate : func,
            selectablestop : func
          }
        };

        handleShinyInput(el, opt, default_shiny_opt);

        $(el).selectable(opt);

      },

      disable : function(el) {

        $(el).selectable('destroy');

      }

    },

    sortable : {

      enable : function(el, opt) {

        var func = function(el, event, ui) {
            var $selected = $(el).children();
            var html = $selected.map(function(i, e){return e.innerHTML;}).get();
            var ids = $selected.map(function(i, e){return shinyjqui.getId(e);}).get();
            return {'id': ids, 'html': html};
          };

        var default_shiny_opt = {
          'order:shinyjqui.df' : {
            sortcreate : func,
            sortupdate : func
          }
        };

        handleShinyInput(el, opt, default_shiny_opt);

        $(el).sortable(opt);

      },

      disable : function(el) {

        $(el).sortable('destroy');

      }

    }

  };

  return {

    getId : function(el) {
      var id = $(el).attr('id');
      if(!id) {
        if($(el).hasClass('shiny-input-container')) {
          // for shiny inputs
          id = $(el).find('.shiny-bound-input').attr('id');
        } else if ($(el).hasClass('jqui-resizable-wrapper')) {
          // for shiny output that is wrapped with a resizable div
          id = $(el).find('.shiny-bound-output').attr('id');
        }
      }
      return id ? id : '';
    },

    msgCallback : function(msg) {

      if(!msg.hasOwnProperty('selector')) {
          console.warn('No selector found');
          return;
        }
      var $els = $(msg.selector).map(function(i, e){
          return getInputContainer(e);
        });

      if(!msg.hasOwnProperty('method')) {
          console.warn('No method found');
          return;
        }
      var method = msg.method;

      if(!msg.hasOwnProperty('func')) {
          console.warn('No func found');
          return;
        }
      var func = msg.func;

      msg = evalJS(msg);

      if(method === 'interaction') {

          $els.removeClass(function(index, className){
            return (className.match (/(^|\s)jqui-interaction-\S+/g) || []).join(' ');
          });

          if(msg.switch === true) {

            $els.each(function(idx, el) {
              console.log('===================');
              console.log('ENABLE: ' + func);
              console.log('ELEMENT: ');
              console.log(el);
              console.log('OPTIONS: ');
              console.log(msg.options);
              console.log('===================');
              interactions[func].enable(el, msg.options);
            });

          } else if(msg.switch === false) {

            $els.each(function(idx, el) {
              console.log('===================');
              console.log('DISABLE: ' + func);
              console.log('ELEMENT: ');
              console.log(el);
              console.log('===================');
              interactions[func].disable(el);
            });

          } else {

            console.warn('Invalid switch: ' + msg.switch);

          }

      } else if(method === 'effect') {

          if(!msg.hasOwnProperty('effect')) {
            console.warn('No effect found');
            return;
          }
          $els[func](msg.effect, msg.options, msg.duration, msg.complete);

      } else if(method === 'class') {

          if(func === 'add' || func === 'remove') {

            if(!msg.hasOwnProperty('className')) {
              console.warn('No className found');
              return;
            }
            $els[func + 'Class'](msg.className,
                                 msg.duration,
                                 msg.easing,
                                 msg.complete);

          } else if(func === 'switch') {

            if(!msg.hasOwnProperty('removeClassName')) {
              console.warn('No removeClassName found');
              return;
            }
            if(!msg.hasOwnProperty('addClassName')) {
              console.warn('No addClassName found');
              return;
            }
            $els[func + 'Class'](msg.removeClassName,
                                 msg.addClassName,
                                 msg.duration,
                                 msg.easing,
                                 msg.complete);

          } else {

            console.warn('Invalid func: ' + msg.func);

          }

      } else {

          console.warn('Invalid method: ' + msg.method);

        }

    },

    init : function() {
      Shiny.addCustomMessageHandler('shinyjqui', shinyjqui.msgCallback);
    }

  };

}();

$(function(){ shinyjqui.init(); });
