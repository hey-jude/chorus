chorus.presenters.Attachment = chorus.presenters.Base.extend({
    url: function() {
        return this.model.hasOwnPage() ? this.model.showUrl() : this.model.downloadUrl();
    },

    iconSrc: function() {
        var iconSize = this.options.iconSize || "icon";
        return this.model.iconUrl({size: iconSize});
    },

    name: function() {
        return this.model.get("name") || this.model.get("objectName") || this.model.get("fileName");
    },

//    replaced with isImageFileType()
//     isImage: function() {
//         return chorus.urlHelpers.getMapping(this.model.get("type")) === "image" || chorus.urlHelpers.getMapping(this.model.get("fileType")) === "image";
//     },

    isImageFiletype: function() {
        return chorus.urlHelpers.getMapping(this.model.get("type")) === "image" || chorus.urlHelpers.getMapping(this.model.get("fileType")) === "image";
    },

    useExternalLink: function() {
        return this.model.useExternalLink();
    }
});
