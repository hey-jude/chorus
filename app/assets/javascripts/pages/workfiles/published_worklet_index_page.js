chorus.pages.PublishedWorkletIndexPage = chorus.pages.Base.include(
        chorus.Mixins.FetchingListSearch
    ).extend({
        constructorName: 'PublishedWorkletIndexPage',

        setup: function(workspaceId) {
            this.collection = new chorus.collections.PublishedWorkletSet();
           // this.model = new chorus.models.Worklet({workspace: {id: workspaceId }});

            this.mainContent = new chorus.views.MainContentList({
                modelClass:"PublishedWorklet",
                collection:this.collection
            });

         //   this.buildPrimaryActions();
            this.collection.fetch();

        },

        buildPrimaryActions: function() {
            //var actions = [{name: 'create_new_worklet', target: chorus.dialogs.WorkletNew}];
            //this.primaryActionPanel = new chorus.views.PrimaryActionPanel({actions: actions});
        }
    });
