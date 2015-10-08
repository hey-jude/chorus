var ChiasmComponent = require("chiasm-component");
var Model = require("model-js");
var mixins = require("./mixins");
// This is an example Chaism plugin that uses D3 to make a box plot. 
// Draws from this Box Plot example http://bl.ocks.org/mbostock/4061502
function BoxPlot() {

  var my = ChiasmComponent({

    margin: {
      left:   30,
      top:    30,
      right:  30,
      bottom: 30
    },
    
    xColumn: Model.None,
    yColumn: Model.None,

    fill: "white",
    stroke: "black",
    strokeWidth: "1px"

  });

  var xScale = d3.scale.ordinal();
  var yScale = d3.scale.linear();
  var rScale = d3.scale.sqrt();

  var svg = d3.select(my.initSVG());
  var g = mixins.marginConvention(my, svg);

  var xAxisG = mixins.xAxis(my, g);
  mixins.xAxisLabel(my, xAxisG);

  var yAxisG = mixins.yAxis(my, g);
  mixins.yAxisLabel(my, yAxisG);

  my.when(["data", "xColumn", "yColumn"], function (data, xColumn, yColumn){
    if(xColumn !== Model.None && yColumn !== Model.None){
      var getX = function (d){ return d[xColumn]; };
      var getY = function (d){ return d[yColumn]; };
      my.boxPlotData = d3.nest().key(getX).entries(data)
        .map(function (d){
          var sorted = d.values.map(getY).sort();
          d.quartileData = quartiles(sorted);
          d.whiskerData = [sorted[0], sorted[sorted.length - 1]];
          return d;
        });
    }
  });

  function quartiles(d) {
    return [
      d3.quantile(d, .25),
      d3.quantile(d, .5),
      d3.quantile(d, .75)
    ];
  }

  my.when(["boxPlotData", "width", "xColumn"], function (boxPlotData, width, xColumn){
    if(xColumn !== Model.None){

      // The key here corresponds to the unique values in the X column.
      my.xScale = xScale
        .domain(boxPlotData.map(function (d){ return d.key; }))
        .rangeBands([0, width], 0.5);
    }
  });

  my.when(["data", "height", "yColumn"], function (data, height, yColumn){
    if(yColumn !== Model.None){
      my.yScale = yScale
        .domain(d3.extent(data, function (d){ return d[yColumn]; }))
        .range([height, 0]);
    }
  });

  my.when([ "boxPlotData", "fill", "stroke", "strokeWidth" ],
      function (boxPlotData, fill, stroke, strokeWidth){

    // The center lines that span the whiskers.
    var center = g.selectAll("line.center").data(boxPlotData);
    center.enter().append("line").attr("class", "center");
    center.exit().remove();
    center
      .attr("x1", function (d){ return xScale(d.key) + (xScale.rangeBand() / 2); })
      .attr("x2", function (d){ return xScale(d.key) + (xScale.rangeBand() / 2); })
      .attr("y1", function (d){ return yScale(d.whiskerData[0]); })
      .attr("y2", function (d){ return yScale(d.whiskerData[1]); })
      .style("stroke", stroke)
      .style("stroke-width", strokeWidth);

    // The top whiskers.
    var whiskerTop = g.selectAll("line.whisker-top").data(boxPlotData);
    whiskerTop.enter().append("line").attr("class", "whisker-top");
    whiskerTop.exit().remove();
    whiskerTop
      .attr("x1", function (d){ return xScale(d.key); })
      .attr("x2", function (d){ return xScale(d.key) + xScale.rangeBand(); })
      .attr("y1", function (d){ return yScale(d.whiskerData[0]); })
      .attr("y2", function (d){ return yScale(d.whiskerData[0]); })
      .style("stroke", stroke)
      .style("stroke-width", strokeWidth);

    // The bottom whiskers.
    var whiskerBottom = g.selectAll("line.whisker-bottom").data(boxPlotData);
    whiskerBottom.enter().append("line").attr("class", "whisker-bottom");
    whiskerBottom.exit().remove();
    whiskerBottom
      .attr("x1", function (d){ return xScale(d.key); })
      .attr("x2", function (d){ return xScale(d.key) + xScale.rangeBand(); })
      .attr("y1", function (d){ return yScale(d.whiskerData[1]); })
      .attr("y2", function (d){ return yScale(d.whiskerData[1]); })
      .style("stroke", stroke)
      .style("stroke-width", strokeWidth);

    // The box that shows the upper and lower quartiles.
    var boxRect = g.selectAll("rect.box").data(boxPlotData);
    boxRect.enter().append("rect").attr("class", "box");
    boxRect.exit().remove();
    boxRect
      .attr("x", function (d){ return xScale(d.key); })
      .attr("width", xScale.rangeBand())
      .attr("y", function (d){ return yScale(d.quartileData[2]); })
      .attr("height", function (d){ return yScale(d.quartileData[0]) - yScale(d.quartileData[2]); })
      .style("stroke", stroke)
      .style("stroke-width", strokeWidth)
      .style("fill", fill);

    // The horizontal line inside the box that shows the median.
    var median = g.selectAll("line.median").data(boxPlotData);
    median.enter().append("line").attr("class", "median");
    median.exit().remove();
    median
      .attr("x1", function (d){ return xScale(d.key) })
      .attr("x2", function (d){ return xScale(d.key) + xScale.rangeBand(); })
      .attr("y1", function (d){ return yScale(d.quartileData[1]); })
      .attr("y2", function (d){ return yScale(d.quartileData[1]); })
      .style("stroke", stroke)
      .style("stroke-width", strokeWidth);
  });

  return my;
}

module.exports = BoxPlot;
