// This file pulls together the required Chiasm components,
// including the visEngineDataLoader component that connects to the random sampling API,
// and outputs a Chiasm constructor with the plugins set up for the Chiasm configuration to access.
var Chiasm = require("chiasm");
var Charts = require("chiasm-charts");
module.exports = function (){

  var chiasm = new Chiasm();

  chiasm.plugins.layout = require("chiasm-layout");
  chiasm.plugins.links = require("chiasm-links");
  chiasm.plugins.datasetLoader = require("chiasm-dataset-loader");
  chiasm.plugins.visEngineDataLoader = require("./visEngineDataLoader");
  chiasm.plugins.dataReduction = require("chiasm-data-reduction");

  chiasm.plugins.scatterPlot = Charts.components.scatterPlot;
  chiasm.plugins.lineChart = Charts.components.lineChart;
  chiasm.plugins.barChart = Charts.components.barChart;
  chiasm.plugins.heatMap = Charts.components.heatMap;
  chiasm.plugins.boxPlot = Charts.components.boxPlot;

  return chiasm;
};
