shinyjqui = function() {

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
          var input_value = func(event, ui);
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


  var evaluateJSExpressions = function(opt, idx) {
    $.each(idx, function( key, value ) {
        if(value === true && opt[key]) {
          opt[key] = eval("(" + opt[key] + ")");
        } else if(typeof value === 'object'){
          evaluateJSExpressions(opt[key], value);
        }
      });
  };

  var evalJS = function(option) {
    var idx = option._js_idx;
    if(idx && typeof idx === 'object') {
      evaluateJSExpressions(option, idx);
    }
    return(option);
  };

  var interactions = {

    draggable : {

      enable : function(el, opt) {

        //el = getInputContainer(el);

        var func = function(event, ui) {
          return $(event.target).position();
        };

        var default_shiny_opt = {
          position : {
            dragcreate : func,
            drag : func
          },
          is_dragging : {
            dragcreate : function(event, ui) {return false;},
            dragstart : function(event, ui) {return true;},
            dragstop : function(event, ui) {return false;}
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
            dropcreate : function(event, ui){return [];},
            dropover : function(event, ui){return shinyjqui.getId(ui.draggable.get(0));}
          },
          drop : {
            dropcreate : function(event, ui){return [];},
            drop : function(event, ui){return shinyjqui.getId(ui.draggable.get(0));}
          },
          out : {
            dropcreate : function(event, ui){return [];},
            dropout : function(event, ui){return shinyjqui.getId(ui.draggable.get(0));}
          },
          dragging : {
            dropcreate : function(event, ui){return [];},
            dropactivate : function(event, ui){
            return shinyjqui.getId(ui.draggable.get(0));},
            dropdeactivate : function(event, ui){return [];}
          },
          dropped : {
            dropcreate : function(event, ui){
              $(event.target).data("shinyjqui_droppedIds", []);
              return [];
            },
            drop : function(event, ui){
              var current_ids = $(event.target).data("shinyjqui_droppedIds");
              var new_id = shinyjqui.getId(ui.draggable.get(0));
              if($.inArray(new_id, current_ids) == -1) current_ids.push(new_id);
              $(event.target).data("shinyjqui_droppedIds", current_ids);
              return current_ids;
            },
            dropout : function(event, ui){
              var current_ids = $(event.target).data("shinyjqui_droppedIds");
              var out_id = shinyjqui.getId(ui.draggable.get(0));
              current_ids.splice($.inArray(out_id, current_ids),1);
              $(event.target).data("shinyjqui_droppedIds", current_ids);
              return current_ids;
            }
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
            resizecreate : function(event, ui){
              return {
                width: $(event.target).width(),
                height: $(event.target).height()
              };
            },
            resize : function(event, ui){
              return ui.size;
            }
          },
          is_resizing : {
            resizecreate : function(event, ui){return false;},
            resizestart : function(event, ui){return true;},
            resizestop : function(event, ui){return false;}
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

        var func = function(event, ui) {
          var $selected = $(event.target).children('.ui-selected');
          var html = $selected.map(function(i, e){return e.innerHTML;}).get();
          var ids = $selected.map(function(i, e){return shinyjqui.getId(e);}).get();
          return {'id': ids, 'html': html};
        };

        var default_shiny_opt = {
          'selected:shinyjqui.df' : {
            selectablecreate : func,
            selectablestop : func
          },
          is_selecting : {
            selectablecreate : function(event, ui) {return false;},
            selectablestart : function(event, ui) {return true;},
            selectablestop : function(event, ui) {return false;},
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

        var func = function(event, ui) {
            var $selected = $(event.target).children();
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
            console.warn('No effect found. Action abort.');
            return;
          }

          if(msg.effect === 'transfer' && (func === 'hide' || func === 'show' || func === 'toggle')) {
            console.warn('The transfer effect cannot be used in hide/show. Action abort.');
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
