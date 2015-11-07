describe("chorus.collections.LdapUserSet", function() {
    beforeEach(function() {
        this.collection = new chorus.collections.LdapUserSet([], { username: "bernard" });
    });

    it("has the right url", function() {
        expect(this.collection.url()).toMatchUrl(window.chorusApi.urlPrefix + "/users/ldap/?username=bernard", {
            paramsToIgnore: ["per_page", "page"]
        });
    });
});
