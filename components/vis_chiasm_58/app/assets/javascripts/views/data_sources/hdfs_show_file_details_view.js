chorus.views.HdfsShowFileDetails = chorus.views.Base.extend({
    templateName: "hdfs_show_file_details",

    events: {
        "click button.visualize": "chiasmConfiguration"
    },

    setup: function() {

    },

    chiasmConfiguration: function() {
        alert("TODO: Chiasm Configuration?  Or DELETEME")
    },

    additionalContext: function(){
        return {
            exampleBoolFromView: true
        }
    }
});