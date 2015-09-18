chorus.Mixins.ClEditor = {

     makeEditor: function($container, inputName, options) {

        options = options || {};

        // which controls appear in the graphic toolbar
        var editorOptions = _.extend(options, {controls: "bold italic | bullets numbering | link unlink"});

        var editor = $container.find("textarea[name='"+ inputName +"']").cleditor(editorOptions)[0];
//         $(editor.doc).find("body").focus();
//         $(editor.doc).find(inputName).focus();
            $(editor).focus();
        return editor;
    },

//     onClickToolbarBold: function(e) {
//         e && e.preventDefault();
//         this.find(".cleditorButton[title='Bold']").click();
//     },

//     onClickToolbarItalic: function(e) {
//         e && e.preventDefault();
//         this.find(".cleditorButton[title='Italic']").click();
//     },

//     onClickToolbarBullets: function(e) {
//         e && e.preventDefault();
//         this.find(".cleditorButton[title='Bullets']").click();
//     },

//     onClickToolbarNumbers: function(e) {
//         e && e.preventDefault();
//         this.find(".cleditorButton[title='Numbering']").click();
//     },

//     onClickToolbarLink: function(e) {
//         e && e.preventDefault();
//         this.find(".cleditorButton[title='Insert Hyperlink']").click();
//         e.stopImmediatePropagation();
//     },

//     onClickToolbarUnlink: function(e) {
//         e && e.preventDefault();
//         this.find(".cleditorButton[title='Remove Hyperlink']").click();
//     },

    getNormalizedText: function($textarea) {
        return $textarea.val()
            .replace(/(<div><br><\/div>)+$/, "")
            .replace(/^<br>$/, "");
    }
};
