$( document ).on('turbolinks:load', function() {
  $('.select2_project').select2({
    minimumInputLength: 1,
    allowClear: false,
    ajax: {
      url: "/projects/select2_index.json",
      dataType: 'json',
      quietMillis: 250,
      type: 'GET',
      data: function(term, page) {
        return {
          q: term,
          page_limit: 10,
          page: page
        };
      },
      results: function(data, page) {
        //var more = (page * 10) < data.total_count;
        var more = (page * 10) < data.meta.total_count;
        var projects = $.map(data.projects, function(project, i) {
          return { id: project.id, text: project.fullname };
        });
        return { results: projects, more: more };
      }
    },
    formatAjaxError: function(jqXHR, textStatus, errorThrown) {
      console.log(jqXHR);
      if (jqXHR.status == 401) {
        window.location.reload();
      } else {
        getErrorMessage(jqXHR, jqXHR.status);
      }
      return errorThrown + " " + jqXHR.responseText;
    },
    initSelection: function(element, callback) {
      var id=$(element).val();
      if (id!=="") {
        $.get("/projects/"+id+".json", function(data_from_json) {
          if(data_from_json)
            callback({ id: data_from_json.id, text: data_from_json.fullname });
        });
      }
    },
    dropdownCssClass: "bigdrop"
  });


});