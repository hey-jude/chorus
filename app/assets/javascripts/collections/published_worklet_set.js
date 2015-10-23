chorus.collections.PublishedWorkletSet = chorus.collections.LastFetchWins.include(
    chorus.Mixins.CollectionFetchingSearch
).extend({
        constructorName: "PublishedWorkletSet",
        model: chorus.models.PublishedWorklet,
        urlTemplate: "touchpoints/",
        searchAttr: "namePattern",
        per_page: 20,

        urlParams: function () {
            return {
                namePattern: this.attributes.namePattern
            };
        }
    });