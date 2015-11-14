describe("chorus.models.TaskReport", function() {
    beforeEach(function() {
        this.model = new chorus.models.TaskReport();
    });

    it("has the right url", function() {
        this.model.set({"id": "45"});
        expect(this.model.url()).toMatchUrl(window.chorusApi.urlPrefix + "/task/45");
    });
});
