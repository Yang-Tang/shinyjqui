var orderInputBinding = new Shiny.InputBinding();

$.extend(orderInputBinding, {

  find: function(scope) {
    return $(scope).find('div.jqui-orderInput');
  },

  getId: function(el) {
    return Shiny.InputBinding.prototype.getId.call(this, el) || el.name;
  },

  getValue: function(el) {
    return $(el).children().map(function(i, e){
        return $(e).attr("data-value");
    }).get();
  },

  setValue: function(el, items) {
    // ensure typeof array even with lenght == 1
    var labels = Array.isArray(items.labels)? items.labels : [items.labels];
    var values = Array.isArray(items.values)? items.values : [items.values];
    $(el).empty();
    $.each(values, function(idx, val) {
      $('<div></div>')
        .text(labels[idx])
        .attr("data-value", val)
        .css("margin", "1px")
        .appendTo($(el));
    });
  },

  getItemClass: function(el) {
    if ($(el).children().length == 0) {
      return ["btn btn-" + "default" + " ui-sortable-handle"]
    }
    return $(el).children().map(function(i, e){
        return $(e).attr("class");
    }).get();
  },

  setItemClass: function(el, item_class) {
    var classes = Array.isArray(item_class)? item_class : [item_class];
    var n = classes.length;
    $(el).children().each(function(i, e){$(e).removeAttr('class').addClass(classes[i%n])});
  },

  subscribe: function(el, callback) {
    $(el).on('sortcreate.orderInputBinding sortupdate.orderInputBinding', function(event) {
      callback(true);
    });
  },

  unsubscribe: function(el) {
    $(el).off('.orderInputBinding');
  },

  receiveMessage: function(el, data) {

    if (data.hasOwnProperty('item_class')) {
      data.item_class = Array.isArray(data.item_class)? data.item_class : [data.item_class];
      data.item_class = $.map(data.item_class, function(v, i) {
        return("btn btn-" + v + " ui-sortable-handle");
      });
    }

    if (data.hasOwnProperty('items')) {
      if (!data.hasOwnProperty('item_class')) {
        data.item_class = this.getItemClass(el);
      }
      this.setValue(el, data.items);
    }

    if (data.hasOwnProperty('item_class')) {
      this.setItemClass(el, data.item_class);
    }

    if (data.hasOwnProperty('label'))
      //this._updateLabel(data.label, this._getLabelNode(el));
      $(el).labels().text(data.label);

    if (data.hasOwnProperty('connect'))
      this._updateConnect(el, data.connect);

    $(el).trigger('sortupdate');
  },

  getState: function(el) {
    return {
      //label: this._getLabelNode(el).text(),
      label: $(this).labels().text(),
      value: this.getValue(el)
    };
  },

  getRatePolicy: function() {
    return {
      policy: 'debounce',
      delay: 250
    };
  },

  _getLabelNode: function(el) {
    return $(el).parent().find('label[for="' + $escape(el.id) + '"]');
  },

  _updateLabel: function(a, b) {
        if ("undefined" != typeof a) {
            if (1 !== b.length)
                throw new Error("labelNode must be of length 1");
            var c = $.isArray(a) && 0 === a.length;
            c ? b.addClass("shiny-label-null") : (b.text(a),
            b.removeClass("shiny-label-null"));
        }
  },

  _updateConnect: function(el, connect) {
    $(el).sortable( "option", "connectWith", connect );
  }

});
Shiny.inputBindings.register(orderInputBinding, 'shinyjqui.orderInput');
