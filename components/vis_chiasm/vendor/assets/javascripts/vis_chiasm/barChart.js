// This is an example Chaism plugin that uses D3 to make a bar chart. 
// Draws from this Bar Chart example http://bl.ocks.org/mbostock/3885304

var ChiasmComponent = require("chiasm-component");
var Model = require("model-js");
var d3 = require("d3");
var mixins = require("./mixins");

function BarChart() {

  var my = ChiasmComponent({

    margin: {
      left:   80,
      top:    30,
      right:  30,
      bottom: 60
    },

    sizeColumn: Model.None,
    sizeLabel: Model.None,

    idColumn: Model.None,
    idLabel: Model.None,

    orientation: "vertical",

    // These properties adjust spacing between bars.
    // The names correspond to the arguments passed to
    // d3.scale.ordinal.rangeRoundBands(interval[, padding[, outerPadding]])
    // https://github.com/mbostock/d3/wiki/Ordinal-Scales#ordinal_rangeRoundBands
    barPadding: 0.1,
    barOuterPadding: 0.1,

    fill: "black",
    stroke: "none",
    strokeWidth: "1px",

  });

  // This scale is for the length of the bars.
  var sizeScale = d3.scale.linear();

  var svg = d3.select(my.initSVG());
  var g = mixins.marginConvention(my, svg);

  var barsG = g.append("g");

  // Desired number of pixels between tick marks.
  my.addPublicProperty("xAxisTickDensity", 50);

  // Translation down from the X axis line (pixels).
  my.addPublicProperty("xAxisLabelOffset", 50);

  var xAxis = d3.svg.axis().orient("bottom"); 
  var xAxisG = g.append("g").attr("class", "x axis");
  var xAxisLabel = xAxisG.append("text")
    .style("text-anchor", "middle")
    .attr("class", "label");

  // Desired number of pixels between tick marks.
  my.addPublicProperty("yAxisTickDensity", 30);

  // Translation left from the Y axis line (pixels).
  my.addPublicProperty("yAxisLabelOffset", 45);

  var yAxis = d3.svg.axis().orient("left"); 
  var yAxisG = g.append("g").attr("class", "y axis");
  var yAxisLabel = yAxisG.append("text")
    .style("text-anchor", "middle")
    .attr("class", "label");

  // TODO think about adding this stuff as configurable
  // .tickFormat(d3.format("s"))
  // .outerTickSize(0);

  my.when("xAxisLabelText", function (xAxisLabelText){
    xAxisLabel.text(xAxisLabelText);
  });
  my.when(["width", "xAxisLabelOffset"], function (width, offset){
    xAxisLabel.attr("x", width / 2).attr("y", offset);
  });

  my.when(["height", "yAxisLabelOffset"], function(height, offset){
    yAxisLabel.attr("transform", [
      "translate(-" + offset + "," + (height / 2) + ") ",
      "rotate(-90)"
    ].join(""));
  });
  my.when("yAxisLabelText", function (yAxisLabelText){
    yAxisLabel.text(yAxisLabelText);
  });

  my.when("height", function (height){
    xAxisG.attr("transform", "translate(0," + height + ")");
  });

  my.when(["idColumn", "dataset"],
      function (idColumn, dataset){

    // This metadata is only present for aggregated numeric columns.
    var meta = dataset.metadata[idColumn];
    var idScale;

    // Handle the case of an aggregated numeric column.
    if(meta){
      idScale = d3.scale.linear();
      idScale.domain(meta.domain);
      idScale.rangeBand = function (){ return Math.abs(idScale(meta.step) - idScale(0)); };
      idScale.rangeBands = function (extent){ idScale.range(extent); };
      idScale.step = meta.step;

    // Handle the case of a string (categorical) column.
    } else {
      idScale = d3.scale.ordinal();
      idScale.domain(dataset.data.map( function(d) { return d[idColumn]; }));
      idScale.step = "";
    }
    my.idScale = idScale;
  });

  my.when("dataset", function (dataset){
    my.data = dataset.data;
    my.metadata = dataset.metadata;
  });

  my.when(["data", "sizeColumn", "idScale", "idColumn", "width", "height", "orientation", "idLabel", "sizeLabel", "barPadding", "barOuterPadding"],
      function (data, sizeColumn, idScale, idColumn, width, height, orientation, idLabel, sizeLabel, barPadding, barOuterPadding){

    if(sizeColumn !== Model.None){

      // TODO separate out this logic.
      sizeScale.domain([0, d3.max(data, function (d){ return d[sizeColumn]; })]);

      if(orientation === "vertical"){

        sizeScale.range([height, 0]);
        idScale.rangeBands([0, width], barPadding, barOuterPadding);

        my.barsX = function(d) { return idScale(d[idColumn]); };
        my.barsY = function(d) { return sizeScale(d[sizeColumn]); };
        my.barsWidth = idScale.rangeBand();
        my.barsHeight = function(d) { return height - my.barsY(d); };

        my.xScale = idScale;
        if(idLabel !== Model.None){
          my.xAxisLabelText = idLabel;
        }

        my.yScale = sizeScale;
        if(sizeLabel !== Model.None){
          my.yAxisLabelText = sizeLabel;
        }

      } else if(orientation === "horizontal"){

        sizeScale.range([0, width]);
        idScale.rangeBands([height, 0], barPadding, barOuterPadding);

        my.barsX = 0;
        my.barsY = function(d) {

          // Using idScale.step here is kind of an ugly hack to get the
          // right behavior for both linear and ordinal id scales.
          return idScale(d[idColumn] + idScale.step);
        };
        my.barsWidth = function(d) { return sizeScale(d[sizeColumn]); };
        my.barsHeight = idScale.rangeBand();

        my.xScale = sizeScale;
        if(sizeLabel !== Model.None){
          my.xAxisLabelText = sizeLabel;
        }

        my.yScale = idScale;
        if(idLabel !== Model.None){
          my.yAxisLabelText = idLabel;
        }
      }
    }
  });

  my.when(["data", "barsX", "barsWidth", "barsY", "barsHeight"],
      function (data, barsX, barsWidth, barsY, barsHeight){

    my.bars = barsG.selectAll("rect").data(data);
    my.bars.enter().append("rect")
    
      // This makes it so that there are no anti-aliased spaces between the bars.
      .style("shape-rendering", "crispEdges");

    my.bars.exit().remove();
    my.bars
      .attr("x",      barsX)
      .attr("width",  barsWidth)
      .attr("y",      barsY)
      .attr("height", barsHeight);

    // Withouth this line, the bars added in the enter() phase
    // will flash as black for a fraction of a second.
    updateBarStyles();

  });

  function updateBarStyles(){
    my.bars
      .attr("fill", my.fill)
      .attr("stroke", my.stroke)
      .attr("stroke-width", my.strokeWidth);
  }
  my.when(["bars", "fill", "stroke", "strokeWidth"], updateBarStyles)

  my.when(["xScale", "width", "xAxisTickDensity"], function (xScale, width, density){
    xAxis.scale(xScale).ticks(width / density);
    xAxisG.call(xAxis);
  });

  my.when(["yScale", "height", "yAxisTickDensity"], function (yScale, height, density){
    yAxis.scale(yScale).ticks(height / density);
    yAxisG.call(yAxis);
  });

  my.destroy = function (){
    my.el.innerHTML = "";
    my.el.parentNode.removeChild(my.el);
  };

  return my;
}

module.exports = BarChart;
