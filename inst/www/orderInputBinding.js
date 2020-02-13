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

  setValue: function(el, items, item_class) {
    $(el).empty();
    item_class = "btn btn-" + item_class + " ui-sortable-handle";
    $.each(items.values, function(idx, val) {
      $('<div></div>')
        .text(items.labels[idx])
        .attr("data-value", val)
        .addClass(item_class)
        .css("margin", "1px")
        .appendTo($(el));
    });
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
    if (data.hasOwnProperty('items') & data.hasOwnProperty('item_class'))
      this.setValue(el, data.items, data.item_class);

    if (data.hasOwnProperty('label'))
      //this._updateLabel(data.label, this._getLabelNode(el));
      $(el).labels().text(data.label);

    if (data.hasOwnProperty('connect'))
      this._updateConnect(el, data.connect);

    $(el).trigger('sortupdate');
  },

  getState: function(el) {
    return {
      label: this._getLabelNode(el).text(),
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
