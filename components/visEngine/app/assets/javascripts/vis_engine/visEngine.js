// This "chiasm" package contains a constructor function that
// includes core Chiasm plugins.
var Chiasm = require("chiasm");

// This is the Chiasm instance that will be constructed,
// and will have the VisEngine--specific data loading plugin available.
var chiasm;

// This function returns the singleton Chiasm instance,
// which gets constructed only the first time this function is called.
module.exports = {
  chiasmInit: function (container){
    if (!chiasm) {
      chiasm = Chiasm(container);

      // Pull in Chiasm modules from
      // https://github.com/chiasm-project/
      chiasm.plugins.layout = require("chiasm-layout"),
      chiasm.plugins.links = require("chiasm-links"),
      chiasm.plugins.dataReduction = require("chiasm-data-reduction"),

      // This is the Chiasm plugin that loads the data from the VisEngine API.
      chiasm.plugins.visEngineDataLoader = require("./visEngineDataLoader"),

      // This is the customized Bar Chart module for Chorus.
      chiasm.plugins.barChart = require("./barChart")
    }
    return chiasm;
  }
};
