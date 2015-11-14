chorus.pages.PublishedWorkletIndexPage = chorus.pages.Base.include(
    chorus.Mixins.FetchingListSearch
).extend({
        constructorName: 'PublishedWorkletIndexPage',

        setup: function () {

            this.collection = new chorus.collections.PublishedWorkletSet();
            this.collection.sortAsc("fileName");
            this.collection.fetch();

            this.setupOnSearched();

            this.mainContent = new chorus.views.MainContentList({
                modelClass: "PublishedWorklet",
                useCustomList: true,
                collection: this.collection,
                title: t("published_worklet.index.header"),
                linkMenus: {
                    sort: {
                        title: t("workfiles.header.menu.sort.title"),
                        options: [
                            {data: "alpha", text: t("workfiles.header.menu.sort.alphabetically")},
                            {data: "date", text: t("workfiles.header.menu.sort.by_date")}
                        ],
                        event: "sort"
                    }
                },
                search: {
                    placeholder: t("published_worklet.search_placeholder"),
                    onTextChange: this.debouncedCollectionSearch()
                },
                contentDetailsOptions: { layout: 'card' }
            });

            this.mainContent.contentHeader.bind("choice:sort", function (choice) {
                var field = choice === "alpha" ? "fileName" : "userModifiedAt";
                this.collection.sortAsc(field);
                this.collection.fetch();
            }, this);
        }
    });
