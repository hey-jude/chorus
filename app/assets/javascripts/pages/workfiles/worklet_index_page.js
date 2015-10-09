chorus.pages.WorkletIndexPage = chorus.pages.Base.include(
        chorus.Mixins.FetchingListSearch
    ).extend({
        constructorName: 'WorkletIndexPage',

        setup: function(workspaceId) {
            this.model = new chorus.models.Worklet({workspace: {id: workspaceId }});

            this.mainContent = new chorus.views.MainContentView({
                model: this.model,
                content: new chorus.views.WorkletView({workspaceId: workspaceId, model: this.model})
            });

        }
    });
