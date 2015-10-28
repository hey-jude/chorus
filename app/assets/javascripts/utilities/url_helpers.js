(function () {
    chorus.urlHelpers = chorus.urlHelpers || {};

    // This mapping actually maps file extensions AND workfile 'fileType' attributes to filename values.
    var map = {
        "afm":"afm",
        "worklet":"worklet",
        "c":"c",
        "c++":"cpp",
        "cc":"cpp",
        "cxx":"cpp",
        "cpp":"cpp",
        "csv":"csv",
        "doc":"doc",
        "docx":"doc",
        "excel":"xls",
        "xls":"xls",
        "xlsx":"xls",
        "h":"c",
        "hpp":"cpp",
        "hxx":"cpp",
        "jar":"jar",
        "java":"java",
        "pdf":"pdf",
        "ppt":"ppt",
        "r":"r",
        "rtf":"rtf",
        "txt":"txt",
        "sql":"sql",
        "image":"image",
        "yml":"yml",
        "m":"m",
        "pl":"pl",
        "py":"py",
        "sas":"sas",
        "tsv":"tsv",
        "gif":"image",
        "png":"image",
        "jpg":"image",
        "jpeg":"image",
        "twb":"tableau",
        "pmml":"pmml",
        "json":"json",
        "am":"am",
        "xml":"xml",
        "js":"js",
        "md":"md",
        "pig":"pig",
        "rb":"rb"
    };

    chorus.urlHelpers.fileIconUrl = function fileIconUrl(key, size) {
        var fileType = key && key.toLowerCase();
        var imageName = (map[fileType] || "plain") + ".png";
        return "/images/workfiles/" + (size || "large") + "/" + imageName;
    };

    chorus.urlHelpers.workspacePath = function(workspaceId) {
        return "#/workspaces/" + workspaceId;
    };

    chorus.urlHelpers.getMapping = function(key) {
        var fileType = key && key.toLowerCase();
        return map[fileType];
    };
    Handlebars.registerHelper('workspacePath', chorus.urlHelpers.workspacePath);
})();
