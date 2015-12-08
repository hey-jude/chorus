//A Chiasm plugin that loads data from the vis_chiasm random sampling API.
var Model = require("model-js");
var ChiasmComponent = require("chiasm-component");
var d3 = require("d3");

module.exports = function (){

  var my = ChiasmComponent({
    dataset_id: Model.None,
    numRows: 5000
  });

  my.when(["dataset_id", "numRows"], function (dataset_id, numRows){
    if(dataset_id !== Model.None){

      // TODO generate the URL for Chester's Hadoop API here.
      // Details on the API here: https://github.com/alpinedatalabs/adl/pull/920
      // e.g. http://localhost:9090/alpinedatalabs/api/v1/json/data/datasources/GPDB/airline.airports/rows?fetch=random&max=10&columns=airport,city&token=c2060462434fb03bc12076f202a36720d279ac35

      var url = [
        "/datasets/" + dataset_id,
        "/chiasm_api_datasets/show_data",
        "?numRows=" + numRows
      ].join("");

      d3.json(url, function(error, dataset) {
        if(error){ throw error; }
        my.dataset = dataset;
      });
    }
  });

  return my;
}
