// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
// require turbolinks
//= require_tree .
// add index.js from vendor/assets/javascripts folder
//= require index

function transfer_all_items(from, to) {
    console.log("transfering items from "  + from + " to " + to);
    items = $("#" + from).children();
    console.log(items);
    for (var item in items ) {
        //console.log(item);
        $( item ).find( 'i').removeClass('fa-plus-circle').removeClass('add-list-item');
        $( item ).find('i').addClass('fa-times-circle').addClass('remove-list-item');
        //$( item ).remove();
        //$( "#" + to ).append( item );
    };

};

function transfer_item(id, target) {
    if ( $("#" + id).closest(".list-left").length != 0  ) {
        add_item(id, target);
    }
    else {
        remove_item(id, target);
    }
};

function add_item(id, target) {
    console.log("add_item called with id = " + id + " and target = " + target );
    var el = $.find(".list-left .list-group #" + id);
    $( el ).find('i').removeClass('fa-plus-circle').removeClass('add-list-item');
    $( el ).find('i').addClass('fa-times-circle').addClass('remove-list-item');
    // need to remove hard reference to available_items
    $( el ).data('transfer-id', 'available_items');
    $( "#" + target ).prepend(el);
    var ac = $("#available-count").data('available-count');
    var cc = $("#current-count").data('current-count');
    console.log("ac = " + ac);
    console.log("cc =  " + cc);
    $("#available-count").data('available-count', (parseInt(ac) - 1));
    $("#current-count").data('current-count', (parseInt(cc) + 1));
    $("#available-count").html("Available Members (" + (parseInt(ac) - 1) + ")");
    $("#current-count").html("Team Members (" + (parseInt(cc) + 1) + ")");
};

function remove_item(id, target) {
    console.log("remove_item called with id = " + id + " and target = " + target );
    var el = $.find(".list-right .list-group #" + id);
    $( el ).find('i').removeClass('fa-times-circle').removeClass('remove-list-item');
    $( el ).find('i').addClass('fa-plus-circle').addClass('add-list-item');
    // Need to remove hard reference to current_items
    $( el ).data('transfer-id', 'current_items');
    /*  $(".list-right .list-group #" + id).remove();  */
    //$(".list-left ul#available_scopes").append(el);
    $( "#" + target ).prepend(el);
};

function submit_dual_list_form(url, collection_id) {
    var items = []
    console.log('submit_form called with url =  ' + url);
    $(collection_id).children().each(function(){
        items.push($( this ).data('item-id'));
    });

    console.log(items);

    $.ajaxSetup({
        'beforeSend': function (xhr){
            xhr.setRequestHeader("Accept", "text/javascript")}
    });
    $.ajax({
        url:  url,
        type: 'put',
        format: 'js',
        data: { 'items' : items}
    })
        .done(function( data ) {
            eval(data);
            if ( console && console.log ) {
                //console.log(data);
            }
        });
};
