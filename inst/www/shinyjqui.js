shinyjqui = function() {

  // If the target element has class "shiny-bound-input", which usually the case
  // when user uses an id to refer to a shiny input, we should redirect this
  // target element to its shiny-input-container so that the whole shiny input
  // but not a part of it would be affected. This is very important when the
  // shiny input are checkboxInput, fileInput, numericInput, selectInput,
  // sliderInput, textInput, textAreaInput and passwordInput whose id-containing
  // elements are located deep inside the shiny-input-container. However, the
  // only exception is actionButton who dosen't have a shiny-input-container.
  var getInputContainer = function(el) {

    // if the target element is not a shiny input, just cancel the operation
    if(!($(el).hasClass("shiny-bound-input"))) {
      return el;
    }
    // if it is a shiny actionBotton, cancel the operation
    if($(el).hasClass("btn")) {
      return el;
    }

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
        // remove keys in default_shiny_opt that have duplicated input_suffix
        // but with a input_handler.
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

  // if the target el has "jqui-wrapper", return the wrapper
  var getWrapper = function(el) {
    if($(el).parent().hasClass("jqui-wrapper")) {
          el = $(el).parent().get(0);
    }
    return(el);
  };

  // Obtained from shiny init_shiny.js
  // Return true if the object or one of its ancestors in the DOM tree has
  // style='display:none'; otherwise return false.
  var isHidden = function(obj) {
    // null means we've hit the top of the tree. If width or height is
    // non-zero, then we know that no ancestor has display:none.
    if (obj === null || obj.offsetWidth !== 0 || obj.offsetHeight !== 0) {
      return false;
    } else if (getStyle(obj, 'display') === 'none') {
      return true;
    } else {
      return(isHidden(obj.parentNode));
    }
  };

  // initiate data("shinyjqui") to store option and status etc.
  var initJquiData = function(el) {
    var data = {
      draggable : { save : {} },
      droppable : { save : {} },
      resizable : { save : {} },
      selectable : { save : {} },
      sortable : { save : {} }
    };
    if(!$(el).data("shinyjqui")) { $(el).data("shinyjqui", data) }
  };

  // Wrap the element when it is a shiny/htmlwidgets output, so that
  // the element's redraw on resizing won't remove the dragging handlers.
  // Shiny actionButton also needs wrapping. The resizable's internal
  // ui-wrapper is not working very well.
  var addWrapper = function(el) {

    if($(el).parent().hasClass("jqui-wrapper")) { return el; }

    var pattern = /action-button|html-widget-output|shiny-.+?-output/;
    if(!pattern.test($(el).attr('class'))) { return el; }

    var $wrapper = $('<div></div>')
      .outerWidth($(el).outerWidth() ? $(el).outerWidth() : '100%')
      .outerHeight($(el).outerHeight() ? $(el).outerHeight() : '100%')
      .css($(el).css(["top", "left"]))
      .addClass('jqui-wrapper');

    var wrapper = $(el)
      .wrap($wrapper)
      .outerWidth('100%')
      .outerHeight('100%')
      .css({top:"0px", left:"0px"})
      .parent().get(0);

      // When applying resizable to element with other interactions already
      // initiated, the interaction options will first be transfered to
      // the wrapper, then be removed from the element
      //var inter_funcs = ["draggable", "droppable", "selectable", "sortable"];
      //$.each(inter_funcs, function(i, v){
        //if($(el).is(".ui-" + v)) {
          //var opt = $(el)[v]("option");
          //$(wrapper)[v](opt);
          //$(el)[v]("destroy");
        //}
      //});

    return wrapper;

  };

  // When an interaction is disabled, check and try to remove the wrapper
  var removeWrapper = function(el) {

    var $el = $(el);

    // cancel operation if it's not a shiny output or any interactions left
    if(!$el.hasClass("jqui-wrapper")) { return; }
    if($el.hasClass("ui-draggable")) { return; }
    if($el.hasClass("ui-droppable")) { return; }
    if($el.hasClass("ui-selectable")) { return; }
    if($el.hasClass("ui-sortable")) { return; }
    if($el.hasClass("ui-resizable")) { return; }

    $el
      .children(".shiny-bound-output")
      .outerWidth($el.outerWidth())
      .outerHeight($el.outerHeight())
      .css($el.css(["top", "left"]))
      .insertAfter($el);

    $el.remove();

  };

  var disableInteraction = function(el, interaction) {
    var $el = $(el);
    if(!$el.hasClass("ui-" + interaction)) {return;}
    $el[interaction]('destroy');
    $el.removeData("shinyjqui");
    removeWrapper(el);
  };

  var interactions = {

    draggable : {

      enable : function(el, opt) {

        var default_shiny_opt = {
          position : {
            dragcreate : function(event, ui) {return $(event.target).position();},
            drag : function(event, ui) {return $(event.target).position();}
          },
          is_dragging : {
            dragcreate : function(event, ui) {return false;},
            dragstart : function(event, ui) {return true;},
            dragstop : function(event, ui) {return false;}
          }
        };

        handleShinyInput(el, opt, default_shiny_opt);

        $(el).draggable(opt);

        initJquiData(el);

      },

      disable : function(el, opt) {
        disableInteraction(el, "draggable");
      }

    },

    droppable : {

      enable : function(el, opt) {

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
              return shinyjqui.getId(ui.draggable.get(0));
            },
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

        initJquiData(el);

      },

      disable : function(el, opt) {
        disableInteraction(el, "droppable");
      }

    },

    resizable : {

      enable : function(el, opt) {

        //if($(el).parent().hasClass('ui-resizable')) return;



        var default_shiny_opt = {
          size : {
            resizecreate : function(event, ui) {
              return {
                width : $(event.target).width(),
                height : $(event.target).height()
              };
            },
            resize : function(event, ui){
              return $(event.target).data("uiResizable").size;
            },
            resizestop : function(event, ui) {
              return $(event.target).data("uiResizable").size;
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

        initJquiData(el);

      },

      disable : function(el, opt) {
        disableInteraction(el, "resizable");
      },

      change : function(el, opt) {

        $(el).width(opt.width).height(opt.height);
        if($(el).hasClass("jqui-wrapper")) {
          $(el)
            .children(".shiny-bound-output")
            .data("shiny-output-binding")
            .onResize();
        }
      //$(el).data("shiny-output-binding").onResize();
      //$(el).trigger({
        //type: 'shiny:visualchange',
        //visible: !isHidden(el),
        //binding: $(el).data('shiny-output-binding')
      //});
      },

      save : function(el, opt) {
        var $el = $(el);
        if(!$el.is(".ui-resizable")) {return;}
        var option  = $el.resizable("option");
        var size = $el.data("uiResizable").size;
        $el.data("shinyjqui").resizable.save.option = option;
        $el.data("shinyjqui").resizable.save.size = size;
      },

      load : function(el, opt) {
        var $el = $(el);
        if(!$el.is(".ui-resizable")) {return;}
        var saving = opt ? opt : $el.data("shinyjqui").resizable.save;
        if(!saving) {return;}
        $el.resizable("option", saving.option);
        interactions.resizable.change($el, saving.size);
        // use "resizecreate" event to update shiny input value.
        // "resize" and "resizestop" event not working
        $el.trigger("resizecreate");
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

        initJquiData(el);

      },

      disable : function(el, opt) {
        disableInteraction(el, "selectable");
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

        var func_set = function(event, ui) {
          var $items = $(event.target).find('.ui-sortable-handle');
          $items.attr('jqui_sortable_idx', function(i, v){return i + 1});
          return $.map($(Array($items.length)),function(v, i){return i + 1});
        };

        var func_get = function(event, ui) {
          var idx = $(event.target)
            .sortable('toArray', {attribute:'jqui_sortable_idx'});
          return $.map(idx, function(v, i){return parseInt(v)});
        };

        var default_shiny_opt = {
          'order' : {
            sortcreate : func_set,
            sortupdate : func_get
          }
        };

        handleShinyInput(el, opt, default_shiny_opt);

        $(el).sortable(opt);

        initJquiData(el);

      },

      disable : function(el, opt) {
        disableInteraction(el, "sortable");
      }

    }

  };

  var update_interactions = {

    resize : function(el, opt) {
      target = getWrapper(el);
      $(target).width(opt.width).height(opt.height);
      //$(el).data("shiny-output-binding").onResize();
      //$(el).trigger({
        //type: 'shiny:visualchange',
        //visible: !isHidden(el),
        //binding: $(el).data('shiny-output-binding')
      //});
    },

    drag : function(el, opt) {
      target = getWrapper(el);
      $(target).position(opt);
    },

    sort : function(el, opt) {
      var $items = $(el).children();
      $items.detach();
      $.each(opt.items, function(i, v) {
        $(el).append($items.get(v - 1));
      });
    }

  };


  return {

    // if el is or part of a shiny tag element, return the shiny id
    getId : function(el) {

      var id = $(el).attr('id');

      // tabsetInput
      if((!id) && $(el).hasClass('tabbable')) {
        id = $(el)
          .find('.shiny-bound-input')
          .attr('id');
      }

      // for shiny inputs
      if(!id) {
        id = $(el)
          .closest('.shiny-input-container')
          .find('.shiny-bound-input')
          .attr('id');
      }

      // for shiny output
      if(!id) {
        id = $(el)
          .closest('.shiny-bound-output')
          .attr('id');
      }

      // for shiny output that is wrapped with a resizable div
      if(!id) {
        id = $(el)
          .closest('.jqui-wrapper')
          .find('.shiny-bound-output')
          .attr('id');
      }

      return id ? id : '';
    },

    msgCallback : function(msg) {

      if(!msg.hasOwnProperty('selector')) {
          console.warn('No selector found');
          return;
      }
      var $els = $(msg.selector);
      $els.removeClass(function(index, className){
        return (className.match (/(^|\s)jqui-interaction-\S+/g) || []).join(' ');
      });
      $els = $els.map(function(i, e){
        e = getInputContainer(e);
        e = addWrapper(e);
        e = getWrapper(e);
        return e;
      });

      if(!msg.hasOwnProperty('type')) {
          console.warn('No type found');
          return;
        }
      var type = msg.type;

      if(!msg.hasOwnProperty('func')) {
          console.warn('No func found');
          return;
        }
      var func = msg.func;

      msg = evalJS(msg);

      console.log('===================');
      console.log('ELEMENTS: ');
      console.log($els);
      console.log('MSG: ');
      console.log(msg);
      console.log('===================');

      if(type === 'interaction') {

          $els.each(function(idx, el) {
            interactions[func][msg.method](el, msg.options);
          });

      } else if(type === 'update_interaction') {

        $els.each(function(idx, el) {
          console.log('===================');
          console.log('ENABLE: ' + func);
          console.log('ELEMENT: ');
          console.log(el);
          console.log('OPTIONS: ');
          console.log(msg.options);
          console.log('===================');

          update_interactions[func](el, msg.options);
        })

      } else if(type === 'effect') {

          if(!msg.hasOwnProperty('effect')) {
            console.warn('No effect found. Action abort.');
            return;
          }

          if(msg.effect === 'transfer' && (func === 'hide' || func === 'show' || func === 'toggle')) {
            console.warn('The transfer effect cannot be used in hide/show. Action abort.');
            return;
          }
          $els[func](msg.effect, msg.options, msg.duration, msg.complete);

      } else if(type === 'class') {

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

          console.warn('Invalid type: ' + msg.type);

        }

    },

    init : function() {
      Shiny.addCustomMessageHandler('shinyjqui', shinyjqui.msgCallback);
    }

  };

}();

$(function(){ shinyjqui.init(); });
