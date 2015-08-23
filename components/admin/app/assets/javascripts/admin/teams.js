// from = available_items indcates Adding all members.
// from = current_items indicates Removing all members.

function transfer_all_items(from, to) {
//    console.log("transfering items from "  + from + " to " + to);
    var ac = parseInt($("#available-count").data('available-count'));
    var cc = parseInt($("#current-count").data('current-count'));
    var totalItems = ac + cc

    $("#" + from).children().each(function() {
        memberId = $(this).attr("id");
        target =  $("#"+ memberId).data('transfer-id');
        transfer_item(memberId,target);
    });

    if(from === "available_items"){
        ac = 0;
        $("#available-count").data('available-count', ac);
        $("#current-count").data('current-count',  (totalItems));

    }else{
        cc = 0;
        $("#available-count").data('available-count', (totalItems));
        $("#current-count").data('current-count',  cc);
    }
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
   // console.log("add_item called with id = " + id + " and target = " + target );
    var el = $.find(".list-left .list-group #" + id);
    $( el ).find('i').removeClass('fa-plus-circle').removeClass('add-list-item');
    $( el ).find('i').addClass('fa-times-circle').addClass('remove-list-item');
    // need to remove hard reference to available_items
    $( el ).data('transfer-id', 'available_items');
    $( "#" + target ).prepend(el);

    var ac = parseInt($("#available-count").data('available-count'));
    var cc = parseInt($("#current-count").data('current-count'));
    $("#available-count").data('available-count', (ac - 1));
    $("#current-count").data('current-count', (cc + 1));

    availableItemsLabel = $("#available-count").html().split("(")['0']
    currentItemslabel =  $("#current-count").html().split("(")['0']
    $("#available-count").html(availableItemsLabel + "(" + (ac - 1) + ")");
    $("#current-count").html(currentItemslabel + "(" + (cc + 1) + ")");
};

function remove_item(id, target) {
    var el = $.find(".list-right .list-group #" + id);
    $( el ).find('i').removeClass('fa-times-circle').removeClass('remove-list-item');
    $( el ).find('i').addClass('fa-plus-circle').addClass('add-list-item');
    // Need to remove hard reference to current_items
    $( el ).data('transfer-id', 'current_items');
    $( "#" + target ).prepend(el);

    var ac = parseInt($("#available-count").data('available-count'));
    var cc = parseInt($("#current-count").data('current-count'));
    $("#available-count").data('available-count', (ac + 1));
    $("#current-count").data('current-count', (cc - 1));
    availableItemsLabel = $("#available-count").html().split("(")['0']
    currentItemslabel =  $("#current-count").html().split("(")['0']
    $("#available-count").html(availableItemsLabel + "(" + (ac + 1) + ")");
    $("#current-count").html(currentItemslabel + "(" + (cc - 1) + ")");
};

function submit_dual_list_form(url, collection_id) {
    var items = []
    console.log('submit_form called with url =  ' + url);
    $(collection_id).children().each(function(){
        items.push($( this ).data('item-id'));
    });

   // console.log(items);

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





