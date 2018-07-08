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

    var $els = $(msg.ui);
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
      elements    : $els,
      type        : msg.type,
      func        : msg.func,
      operation   : msg.operation,
      options     : msg.options
    };
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

    // initiate data("shinyjqui") to store option and state etc.
  var addJquiData = function(el) {
    var data = {
      draggable : { save : {} },
      droppable : { save : {} },
      resizable : { save : {} },
      selectable : { save : {} },
      sortable : { save : {} }
    };
    if(!$(el).data("shinyjqui")) { $(el).data("shinyjqui", data) }
  };

  var removeJquiData = function(el) {

    var $el = $(el);

    // cancel operation if it's not a shiny output or any interactions left
    if(!$el.hasClass("jqui-wrapper")) { return; }
    if($el.hasClass("ui-draggable")) { return; }
    if($el.hasClass("ui-droppable")) { return; }
    if($el.hasClass("ui-selectable")) { return; }
    if($el.hasClass("ui-sortable")) { return; }
    if($el.hasClass("ui-resizable")) { return; }

    $el.removeData("shinyjqui");

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

  // if the target el has "jqui-wrapper", return the wrapper
  var getWrapper = function(el) {
    if($(el).parent().hasClass("jqui-wrapper")) {
          el = $(el).parent().get(0);
    }
    return(el);
  };

  // add index to selectable, sortable and draggable-connectToSortable items
  // for bookmarking, called after interaction created
  var addIndex = function(el) {
    var $el = $(el);
    var id = shinyjqui.getId(el);

    if($el.hasClass("ui-sortable") && id) {
      $el
        .find('.ui-sortable-handle')
        .attr('jqui_sortable_idx', function(i, v){
          return id + "__" + (i + 1);
        });
        // trigger "sortcreate" again to update input value of bookmark state
        $el.trigger("sortcreate");
    }

    if($el.hasClass("ui-draggable") &&
       $el.draggable("option", "connectToSortable") &&
       !($el.is("[jqui_sortable_idx]"))) {
      var n = $(".ui-draggable").filter("[jqui_sortable_idx]").length;
      $el.attr("jqui_sortable_idx", n + 1);
    }

    if($el.hasClass("ui-selectable") && id) {
      $el
        .find('.ui-selectee')
        .attr('jqui_selectable_idx', function(i, v){
              return id + "__" + (i + 1);
        });
        $el.trigger("selectablecreate");
    }

  };

  var removeIndex = function(el) {
    var $el = $(el);

    if(!$el.hasClass("ui-selectable")) {
      $el
      .find(".ui-selectee")
      .removeAttr("jqui_seletable_idx");
    }

    if(!$el.hasClass("ui-sortable")) {
      $el
      .find(".ui-sortable-handle")
      .removeAttr("jqui_sortable_idx");
    }

    if(!$el.hasClass("ui-draggable")) {
      $el.removeAttr("jqui_sortable_idx");
    }

  };

  var interaction_settings = {

    draggable : {

      getState : function(el) {
        return $(el).offset();
      },

      setState : function(el, state) {
        var $el = $(el);

        //$(el).position({
         // my : "left top",
          //at : "left+" + state.left + " top+" + state.top,
          //of : "body"
        //});
        //$(el).data("uiDraggable")._mouseStop(null);

        var start = new $.Event("mousedown", {
            pageX: $el.offset().left,
            pageY: $el.offset().top
        });
        var end = new $.Event("mouseup", {
            pageX: state.left,
            pageY: state.top
        });
        $el.data("uiDraggable")._mouseStart(start);
        $el.data("uiDraggable")._mouseDrag(end);
        $el.data("uiDraggable")._mouseStop(end);
      },

      shiny : {
        "_shinyjquiBookmarkState__draggable" : {
          "dragcreate dragstop" : function(event, ui) {
            return interaction_settings.draggable.getState(event.target);
          }
        },
        position : {
          "dragcreate drag dragstop" : function(event, ui) {
            return $(event.target).position();
          }
        },
        is_dragging : {
          "dragcreate dragstop" : function(event, ui) {return false;},
          "dragstart" : function(event, ui) {return true;}
        }
      }

    },

    droppable : {

      getState : function(el) {
        return;
      },

      setState : function(el, state) {

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

      getState : function(el) {
        return {width: $(el).width(), height: $(el).height()};
      },

      setState : function(el, state) {
        var $el = $(el);

        // idea from https://stackoverflow.com/questions/2523522/how-to-trigger-jquery-resizable-resize-programmatically
        var start = new $.Event("mousedown", { pageX: 0, pageY: 0 });
        var end = new $.Event("mouseup", {
            pageX: state.width - $el.width(),
            pageY: state.height - $el.height()
        });
        $el.data("uiResizable").axis = 'se';
        $el.data("uiResizable")._mouseStart(start);
        $el.data("uiResizable")._mouseDrag(end);
        $el.data("uiResizable")._mouseStop(end);
      },

      shiny : {
        "_shinyjquiBookmarkState__resizable" : {
          "resizecreate resizestop" : function(event, ui) {
            return interaction_settings.resizable.getState(event.target);
          }
        },
        size : {
          "resizecreate resize resizestop" : function(event, ui) {
            return {
              width : $(event.target).width(),
              height : $(event.target).height()
            };
          }
        },
        is_resizing : {
          "resizecreate resizestop" : function(event, ui){return false;},
          "resizestart" : function(event, ui){return true;}
        }
      }

    },

    selectable : {

      getState : function(el) {
        var $selected = $(el).find(".ui-selected");
        var index = $selected.map(function(i, e) {
          return $(e).attr("jqui_selectable_idx");
        }).get();
        return {
          selected : $selected, // for client mode
          index : index // for shiny bookmarking mode
        };
      },

      setState : function(el, state) {
        var $el = $(el);

        // get "ui-selected" and additional classes
        var sel_class = $el.selectable("option", "classes.ui-selected");
        sel_class = sel_class ? "ui-selected " + sel_class : "ui-selected";

        // The value of `state` is different in client mode and bookmarking
        // mode. In client mode, `state.selected` is a jquery object of selected
        // items; In bookmarking mode, `state.selected` is an empty string,
        // instead, `state.index` will be used to generate the selected items.
        var $selected;
        if(state.selected instanceof jQuery) {
          // client mode
          $selected = state.selected;
        } else {
          // shiny bookmarking mode
          if(!Array.isArray(state.index)) {
            // if there is only one index, change it to an array
            state.index = Array(state.index);
          }
          $selected = $(state.index).map(function(i, v) {
            return $("[jqui_selectable_idx=" + v + "]").get(0)
          });
        }

        // idea from https://stackoverflow.com/questions/3140017/how-to-programmatically-select-selectables-with-jquery-ui
        $el
          .find(".ui-selected")
          .not($selected)
          .removeClass(sel_class)
          .addClass("ui-unselecting");

        $selected
          .not(".ui-selected")
          .addClass("ui-selecting");

        $el.data("uiSelectable")._mouseStop(null);
      },

      shiny : {
        "_shinyjquiBookmarkState__selectable" : {
          "selectablecreate selectablestop" : function(event, ui) {
            var state = interaction_settings.selectable.getState(event.target);
            state.selected = "";
            return state;
          }
        },
        'selected:shinyjqui.df' : {
          "selectablecreate selectablestop" : function(event, ui) {
            var $selected = $(event.target).find('.ui-selected');
            var text = $selected.map(function(i, e){
              // use empty string for `undefined` to keep the same length as ids
              return e.innerText ? e.innerText : ""
            }).get();
            var ids = $selected.map(function(i, e){
              return shinyjqui.getId(e)
            }).get();
            return {'id': ids, 'text': text};
          }
        },
        is_selecting : {
          "selectablecreate selectablestop" : function(event, ui) {return false;},
          selectablestart : function(event, ui) {return true;}
        }
      }

    },

    sortable : {

      getState : function(el) {
        // .ui-draggable are items from draggable-connectToSortable,
        // this should be more restrict in later changes
        var $items = $(el).find(".ui-sortable-handle,.ui-draggable");
        // don't use toArray here
        var index = $items.map(function(i, e) {
          return $(e).attr("jqui_sortable_idx");
        }).get();
        return {
          items : $items, // for client mode
          index : index // for shiny bookmarking mode
        };
      },

      setState : function(el, state) {
        var $el = $(el);

        var $items_to_restore;
        if(state.items instanceof jQuery) {
          // client mode
          $items_to_restore = state.items;
        } else {
          // shiny bookmarking mode
          if(!Array.isArray(state.index)) {
            // if there is only one index, change it to an array
            state.index = Array(state.index);
          }
          $items_to_restore = $(state.index).map(function(i, v) {
            return $("[jqui_sortable_idx=" + v + "]").get(0)
          });

        }

        var $items_to_remove = $el.find(".ui-sortable-handle");

        // use $el instead in case no item to remove
        var $container = $items_to_remove.length ? $items_to_remove.parent() : $el

        // Use this to store the container of restore items. if the item is from
        // other sortable group, its container will be different from current
        // $el, then should trigger "sortupdate" of that sortable group to update
        // shiny input values.
        var $thiscontainer;
        $items_to_restore.each(function(i, e) {
          if($(e).hasClass("ui-draggable")) {
            $(e).clone().appendTo($container);
          } else {
            $thiscontainer = $(e).closest(".ui-sortable");
            $(e).appendTo($container);
            // also trigger "sortupdate" of other container
            if(!$thiscontainer.is($el)) {
              $thiscontainer.trigger("sortupdate");
            }
          }
        });
        //$container.append($items_to_restore);
        // this doesn't trigger "sortupdate" ?
        //$el.data("uiSortable")._mouseStop(null);
        $el.trigger("sortupdate");
      },

      shiny : {
        "_shinyjquiBookmarkState__sortable" : {
          "sortcreate sortupdate" : function(event, ui) {
            var state = interaction_settings.sortable.getState(event.target);
            state.items = "";
            return state;
          }
        },
        "order:shinyjqui.df" : {
          "sortcreate sortupdate" : function(event, ui) {
            var $items = $(event.target).find('.ui-sortable-handle');
            var text = $items.map(function(i, e){
              // use empty string for `undefined` to keep the same length as ids
              return e.innerText ? e.innerText : ""
            }).get();
            var ids = $items.map(function(i, e){
              return shinyjqui.getId(e)
            }).get();
            return {'id': ids, 'text': text};
          }
        }
      }

    }

  };

  var interaction = {

    enable : function(el, interaction, opt) {
      handleShinyInput(el, opt, interaction_settings[interaction].shiny);
      $(el)[interaction](opt); // initiate interaction and set options
      $(el)[interaction]("enable"); // enable interaction
      addJquiData(el);
      addIndex(el);
    },

    disable : function(el, interaction, opt) {
      handleShinyInput(el, opt, interaction_settings[interaction].shiny);
      $(el)[interaction](opt); // initiate interaction and set options
      $(el)[interaction]("disable"); // disable interaction
    },

    destroy : function(el, interaction, dummyarg) {
      var $el = $(el);
      if(!$el.hasClass("ui-" + interaction)) {
        console.warn("Interaction not initiated. Operation abort.");
        return;
      }
      $el[interaction]("destroy");
      removeJquiData(el);
      removeWrapper(el);
      removeIndex(el);
    },

    save : function(el, interaction, opt) {
      var $el = $(el);
      handleShinyInput(el, opt, interaction_settings[interaction].shiny);
      $el[interaction](opt); // initiate interaction and set options
      $el.data("shinyjqui")[interaction].save = {
        option : $el[interaction]("option"),
        state : interaction_settings[interaction].getState(el)
      };
    },

    load : function(el, interaction, save) {
      var $el = $(el);
      if(!$el.hasClass("ui-" + interaction)) {
        console.warn("Interaction not initiated. Operation abort.");
        return;
      }
      var saving = save ? save : $el.data("shinyjqui")[interaction].save;
      if(!saving) {
        console.warn("Nothing can be load. Operation abort.");
        return;
      }
      if(saving.option) {
        $el[interaction]("option", saving.option);
      }
      if(saving.state) {
        interaction_settings[interaction].setState(el, saving.state);
      }
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
      var operation = msg.operation;
      var func = msg.func;
      var opt = msg.options;

      if(type === 'interaction') {

          $els.each(function(idx, el) {interaction[operation](el, func, opt);});

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
