;(function () {
    chorus.utilities = chorus.utilities || {};

    var map = {
        sql: "text/x-plsql",
        rb: "text/x-ruby",
        py: "text/x-python",
        r: "text/x-rsrc",
        pig: "text/x-pig",
        js: "text/javascript",
        md: "text/x-markdown"
    };

    chorus.utilities.mime = function mime(ext) {
        return (map[ext] || "text/plain");
    };

})();
