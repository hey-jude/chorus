
//A Chiasm plugin that loads data from the vis_chiasm random sampling API.
var Model = require("model-js");
var ChiasmComponent = require("chiasm-component");
var d3 = require("d3");
var dsvDataset = require("dsv-dataset");

module.exports = function (){

  var my = ChiasmComponent({
    dataset_id: Model.None,
    numRows: 1000
  });

  my.when(["dataset_id", "numRows"], function (dataset_id, numRows){
    if(dataset_id !== Model.None){

      var columnsPath = "datasets/" + dataset_id + "/chiasm_api_datasets/show_column_data";
      var dataPath = "datasets/" + dataset_id + "/chiasm_api_datasets/show_data";

      dataPath += "?numRows=" + numRows;

      d3.json(columnsPath, function(error, columns) {
        if(error){ throw error; }
        my.metadata = { columns: columns };
      });

      d3.xhr(dataPath, function (error, xhr){
        if(error){ throw error; }
        my.dsvString = xhr.response;
      });
    }
  });

  my.when(["dsvString", "metadata"], function (dsvString, metadata){
    my.dataset = dsvDataset.parse({
      dsvString: dsvString, 
      metadata: metadata
    });
    my.data = my.dataset.data;
  });

  return my;
};