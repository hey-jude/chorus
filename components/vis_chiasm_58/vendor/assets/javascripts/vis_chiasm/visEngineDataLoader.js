//A Chiasm plugin that loads data from the vis_chiasm random sampling API.
var Model = require("model-js");
var ChiasmComponent = require("chiasm-component");
var d3 = require("d3");

module.exports = function (){

  var my = ChiasmComponent({
    dataSourceName: Model.None,
    token: Model.None,
    path: Model.None,
    numRows: 5000
  });

  //Sample API Output:
  //
  // https://10.0.0.204:8443/alpinedatalabs/api/v1/json/data/datasources/CDH5/Datasets/IrisDataset.csv/rows?fetch=random&max=10&token=b93c4adf841f74b24f72828bee27d665fa5968fa

//  var sampleOutput = {
//    "status": "OK",
//    "result": {
//      "dsvString": ["5.1,3.5,1.4,0.2,Iris-setosa", "5.8,4,1.2,0.2,Iris-setosa", "5.5,4.2,1.4,0.2,Iris-setosa", "4.8,3.4,1.6,0.2,Iris-setosa", "4.9,3,1.4,0.2,Iris-setosa", "4.3,3,1.1,0.1,Iris-setosa", "5,3.6,1.4,0.2,Iris-setosa", "5.8,2.7,4.1,1,Iris-versicolor", "5.5,3.5,1.3,0.2,Iris-setosa"],
//      "metadata": {
//        "format": "csv",
//        "delimiter": ",",
//        "columns": [{
//          "name": "sepal_length",
//          "type": "number"
//        }, {
//          "name": "sepal_width",
//          "type": "number"
//        }, {
//          "name": "petal_length",
//          "type": "number"
//        }, {
//          "name": "petal_width",
//          "type": "number"
//        }, {
//          "name": "class",
//          "type": "string"
//        }]
//      }
//    }
//  };

  // Dummy data to test the rest of the pipeline.
  // TODO replace this with the real response from the API.
  my.dataset = {
      data: [
          {name: "Jane", age: 31, birthday: new Date(1985, 1, 15)},
          {name: "Joe", age: 29, birthday: new Date(1986, 11, 17)},
          {name: "Jim", age: 20, birthday: new Date(1986, 11, 17)},
          {name: "John", age: 16, birthday: new Date(1986, 11, 17)}
      ],
      metadata:{
          columns: [
              { name: "name", type: "string" },
              { name: "age", type: "number" },
              { name: "birthday", type: "date" }
          ]
      }
  };

  my.when(["dataSourceName", "numRows", "token", "path"],
      function (dataSourceName, numRows, token, path){
    if(defined([dataSourceName, numRows, token, path])){

      // TODO generate the URL for Chester's Hadoop API here.
      // Details on the API here: https://github.com/alpinedatalabs/adl/pull/920

      var url = [
        //"https://10.0.0.204:8443",
        "/alpinedatalabs/api/v1/json/data/datasources/",
        dataSourceName,
        "/",
        path,
        // HDFS - will be path (no leading slash)
        // DB - database.schema.table
        // Hive - database.table
        "/rows?",
        "fetch=random", // fetch=first is another option
        "&max=" + numRows,

        // TODO put this in the XHR header.
        "&token=" + token
      ].join("");

      console.log("Should fetch data from " + url);

      // Commented out because this currently breaks badly.

      // Fetch the data over XHR.
      // TODO modify this call to put the token into the header
      // instead of having it as a URL parameter.
      //d3.json(url, function(error, dataset) {
      //  if(error){ throw error; }
      //  my.dataset = dataset;
      //});
    }
  });

  return my;

  function defined(arr){
    return !arr.some(function (d){
      return d == Model.None;
    });
  }
}

