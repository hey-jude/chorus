// This file pulls together the required Chiasm components,
// including the visEngineDataLoader component that connects to the random sampling API,
// and outputs a Chiasm constructor with the plugins set up for the Chiasm configuration to access.
var Chiasm = require("chiasm");
module.exports = function (){

  var chiasm = new Chiasm();

  chiasm.plugins.layout = require("chiasm-layout");
  chiasm.plugins.links = require("chiasm-links");
  chiasm.plugins.dsvDataset = require("chiasm-dsv-dataset");
  chiasm.plugins.visEngineDataLoader = require("./visEngineDataLoader");
  chiasm.plugins.dataReduction = require("chiasm-data-reduction");

  chiasm.plugins.barChart = require("./barChart.js");
  chiasm.plugins.heatMap = require("./heatMap.js");
  chiasm.plugins.boxPlot = require("./boxPlot.js");
  chiasm.plugins.lineChart = require("./lineChart.js");
  chiasm.plugins.dummyVis = require("./dummyVis.js");

  return chiasm;
};
