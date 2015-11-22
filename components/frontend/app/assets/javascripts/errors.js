// TODO remove when final
$(document).on('click', ".errors a.close_errors", function(e) {
    e.preventDefault();
    $(e.target).closest(".errors").empty().addClass("hidden");
});