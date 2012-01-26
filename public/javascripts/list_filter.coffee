@oar = window.oar ? {}

$ ->

  # custom css expression for a case-insensitive contains()
  jQuery.expr[':'].Contains = (a,i,m) ->
    (a.textContent || a.innerText || "").toUpperCase().indexOf(m[3].toUpperCase()) >= 0

  # header is any element
  # list is an ul
  oar.listFilter = (header, list) ->
    # add the filter input to the header
    form = $("<form>").attr({"class":"filterform","action":"#"})
    input = $("<input>").attr({"class":"filterinput","type":"text","placeholder":"Type here to search a project..."})
    $(form).append(input).appendTo(header)

    $(input).change ->
      filter = $(this).val()
      if(filter)
        $(list).find(".project_title:not(:Contains(#{filter}))").parent().slideUp()
        $(list).find(".project_title:Contains(#{filter})").parent().slideDown()
      else
        $(list).find("li").slideDown()
      false

    $(input).keyup ->
      $(this).change()


