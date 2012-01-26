(function() {
  var _ref;

  this.oar = (_ref = window.oar) != null ? _ref : {};

  $(function() {
    jQuery.expr[':'].Contains = function(a, i, m) {
      return (a.textContent || a.innerText || "").toUpperCase().indexOf(m[3].toUpperCase()) >= 0;
    };
    return oar.listFilter = function(header, list) {
      var form, input;
      form = $("<form>").attr({
        "class": "filterform",
        "action": "#"
      });
      input = $("<input>").attr({
        "class": "filterinput",
        "type": "text",
        "placeholder": "Type here to search a project..."
      });
      $(form).append(input).appendTo(header);
      $(input).change(function() {
        var filter;
        filter = $(this).val();
        if (filter) {
          $(list).find(".project_title:not(:Contains(" + filter + "))").parent().slideUp();
          $(list).find(".project_title:Contains(" + filter + ")").parent().slideDown();
        } else {
          $(list).find("li").slideDown();
        }
        return false;
      });
      return $(input).keyup(function() {
        return $(this).change();
      });
    };
  });

}).call(this);
