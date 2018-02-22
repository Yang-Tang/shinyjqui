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

  var handleServerMsg = function(msg) {

    msg = evalJS(msg);

    var $els = $(msg.selector);
    if(!$els) {
      console.warn("The selector didn't match any element. Operation abort.");
      return;
    }
    $els.removeClass(function(index, className){
      return (className.match (/(^|\s)jqui-interaction-\S+/g) || []).join(' ');
    });
    $els = $els.map(function(i, e){
      e = getInputContainer(e);
      e = addWrapper(e);
      e = getWrapper(e);
      return e;
    });

    console.log('===================');
    console.log('ELEMENTS: ');
    console.log($els);
    console.log('MSG: ');
    console.log(msg);
    console.log('===================');

    return {
      elements : $els,
      type     : msg.type,
      func     : msg.func,
      method   : msg.method,
      options  : msg.options
    };
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

  var removeIndex = function(el) {
    var $el = $(el);

    if($el.hasClass("ui-selectable")) { return; }
    if($el.hasClass("ui-sortable")) { return; }

    $el
      .find(".ui-sortable-handle,.ui-selectee")
      .removeAttr("jqui_idx");

  };

  var interaction_settings = {

    draggable : {

      getStatus : function(el) {
        return $(el).position();
      },

      setStatus : function(el, status) {
        $(el).position({
          my : "left top",
          at : "left+" + status.left + " top+" + status.top,
          of : $(el).parent()
        });
        $(el).data("uiDraggable")._mouseStop(null);
      },

      shiny : {
        position : {
          dragcreate : function(event, ui) {return $(event.target).position();},
          drag : function(event, ui) {return $(event.target).position();},
          dragstop : function(event, ui) {return $(event.target).position();}
        },
        is_dragging : {
          dragcreate : function(event, ui) {return false;},
          dragstart : function(event, ui) {return true;},
          dragstop : function(event, ui) {return false;}
        }
      }

    },

    droppable : {

      getStatus : function(el) {
        return;
      },

      setStatus : function(el, status) {

      },

      shiny : {
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
      }

    },

    resizable : {

      getStatus : function(el) {
        return {width: $(el).width(), height: $(el).height()};
      },

      setStatus : function(el, status) {
        var $el = $(el);
        //$el.width(status.width).height(status.height);
        //if($el.hasClass("jqui-wrapper")) {
          //$el
            //.children(".shiny-bound-output")
            //.data("shiny-output-binding")
            //.onResize();
        //}

        // idea from https://stackoverflow.com/questions/2523522/how-to-trigger-jquery-resizable-resize-programmatically
        var start = new $.Event("mousedown", { pageX: 0, pageY: 0 });
        var end = new $.Event("mouseup", {
            pageX: status.width - $el.width(),
            pageY: status.height - $el.height()
        });
        $el.data("uiResizable").axis = 'se';
        $el.data("uiResizable")._mouseStart(start);
        $el.data("uiResizable")._mouseDrag(end);
        $el.data("uiResizable")._mouseStop(end);
      },

      shiny : {
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
      }

    },

    selectable : {

      getStatus : function(el) {
        //var $selected = $el.find(".ui-selected");
        //status = $selected.map(function(i, e){
          //return parseInt($(e).attr("jqui_idx"));
        //});
        return $(el).find(".ui-selected");
      },

      setStatus : function(el, status) {
        var $el = $(el);
        // idea from https://stackoverflow.com/questions/3140017/how-to-programmatically-select-selectables-with-jquery-ui

        // get "ui-selected" and additional classes
        var sel_class = $el.selectable("option", "classes.ui-selected");
        sel_class = sel_class ? "ui-selected " + sel_class : "ui-selected";

        $el
          .find(".ui-selected")
          .not(status)
          .removeClass(sel_class)
          .addClass("ui-unselecting");

        status
          .not(".ui-selected")
          .addClass("ui-selecting");

        $el.data("uiSelectable")._mouseStop(null);
      },

      shiny : {
        'selected:shinyjqui.df' : {
          "selectablecreate selectablestop" : function(event, ui) {
            var $selected = $(event.target).children('.ui-selected');
            var html = $selected.map(function(i, e){return e.innerHTML;}).get();
            var ids = $selected.map(function(i, e){return shinyjqui.getId(e);}).get();
            return {'id': ids, 'html': html};
          }
        },
        is_selecting : {
          "selectablecreate selectablestop" : function(event, ui) {return false;},
          selectablestart : function(event, ui) {return true;}
        }
      }

    },

    sortable : {

      getStatus : function(el) {
        //var idx = $el.sortable('toArray', {attribute:'jqui_idx'});
        //status = $.map(idx, function(v, i){return parseInt(v)});
        return $(el).find(".ui-sortable-handle");
      },

      setStatus : function(el, status) {
        var $el = $(el);
        var $items = $el.find(".ui-sortable-handle");
        var $container = $items.parent();
        $items.detach();
        $container.append(status);
        // this doesn't trigger "sortupdate" ?
        //$el.data("uiSortable")._mouseStop(null);
        $el.trigger("sortupdate");
        //var selector;
        //$.each(status, function(i, v) {
          //selector = "[jqui_idx=" + v + "]";
          //$container.append($items.filter(selector));
        //});
      },

      shiny : {
        index : {
          sortcreate : function(event, ui) {
            var $items = $(event.target).find('.ui-sortable-handle');
            $items.attr('jqui_idx', function(i, v){return i + 1});
            return $.map($(Array($items.length)),function(v, i){return i + 1});
          },
          sortupdate : function(event, ui) {
            var idx = $(event.target)
              .sortable('toArray', {attribute:'jqui_idx'});
            return $.map(idx, function(v, i){return parseInt(v)});
          }
        },
        order : {
          "sortcreate sortupdate" : function(event, ui) {
            var $selected = $(event.target).children();
            var html = $selected.map(function(i, e){return e.innerHTML;}).get();
            var ids = $selected.map(function(i, e){return shinyjqui.getId(e);}).get();
            return {'id': ids, 'html': html};
          }
        }
      }

    }

  };

  var interaction = {

    enable : function(el, interaction, opt) {
      handleShinyInput(el, opt, interaction_settings[interaction].shiny);
      $(el)[interaction](opt);
      initJquiData(el);
    },

    disable : function(el, interaction, dummyarg) {
      var $el = $(el);
      if(!$el.hasClass("ui-" + interaction)) {return;}
      $el[interaction]('destroy');
      $el.removeData("shinyjqui");
      removeWrapper(el);
      removeIndex(el);
    },

    save : function(el, interaction, dummyarg) {
      var $el = $(el);
      if(!$el.hasClass("ui-" + interaction)) {return;}
      $el.data("shinyjqui")[interaction].save = {
        option : $el[interaction]("option"),
        status : interaction_settings[interaction].getStatus(el)
      };
    },

    load : function(el, interaction, save) {
      var $el = $(el);
      if(!$el.hasClass("ui-" + interaction)) {return;}
      var saving = save ? save : $el.data("shinyjqui")[interaction].save;
      if(!saving) {return;}
      $el[interaction]("option", saving.option);
      interaction_settings[interaction].setStatus(el, saving.status);
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

      msg = handleServerMsg(msg);
      if(!msg) { return; }
      var $els = msg.elements;
      var type = msg.type;
      var method = msg.method;
      var func = msg.func;
      var opt = msg.options;

      if(type === 'interaction') {

          $els.each(function(idx, el) {interaction[method](el, func, opt);});

      } else if(type === 'effect') {

          $els[func](opt);

      } else if(type === 'class') {

          if(func === 'add' || func === 'remove') {
            $els[func + 'Class'](opt.className, opt);
          } else if(func === 'switch') {
            $els.switchClass(opt.removeClassName, opt.addClassName, opt);
          }

      }

    },

    init : function() {
      Shiny.addCustomMessageHandler('shinyjqui', shinyjqui.msgCallback);
    }

  };

}();

$(function(){ shinyjqui.init(); });
