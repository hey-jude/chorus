describe("chorus.dialogs.DatasetsAttach", function() {
    beforeEach(function() {
        this.datasets = new chorus.collections.DatasetSet([
            fixtures.datasetSandboxTable(),
            fixtures.datasetSandboxTable()
        ], {workspaceId: "33"});

        this.dialog = new chorus.dialogs.DatasetsAttach({ workspaceId : "33" });
        this.dialog.render();
    });

    it("enables multi-selection", function() {
        expect(this.dialog.multiSelection).toBeTruthy();
    });

    it("fetches the results sorted by objectName", function() {
        var url = this.server.lastFetch().url
        expect(url).toHaveUrlPath("/edc/workspace/33/dataset");
        expect(url).toContainQueryParams({ sidx: "objectName", sord: "asc" });
    });

    describe("when the fetch completes", function() {
        beforeEach(function() {
            this.server.completeFetchFor(this.datasets, this.datasets.models, { sidx: "objectName", sord: "asc" });
        });

        it("only fetches one page initially", function() {
            expect(this.server.requests.length).toBe(1);
        });

        it("shows the pagination controls", function() {
            expect(this.dialog.$("a.next")).not.toHaveClass("hidden");
        });

        it("has the correct submit button text", function() {
            expect(this.dialog.$('button.submit')).toContainTranslation("actions.dataset_attach")
        });

        it("has the correct iconUlr", function() {
            expect(this.dialog.$('li:eq(0) img')).toHaveAttr('src', this.datasets.at(0).iconUrl({size: 'medium'}));
        });

        it("has the correct name", function() {
            expect(this.dialog.$('li:eq(0) .name')).toContainText(this.datasets.at(0).get("objectName"));
        });

        it("has the correct search placeholder text", function() {
            expect(this.dialog.$("input").attr("placeholder")).toMatchTranslation("dataset.dialog.search");
        });
    });
});
