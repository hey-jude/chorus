// This is an example Chaism plugin that uses D3.  A colored rectangle is
// created with an X in the background and text in the foreground.  The X in the
// background is interactive. Clicking and dragging it updates `lineWidth`.
function DummyVis() {

  // Construct a Chiasm component instance,
  // specifying default values for public properties.
  var my = ChiasmComponent({

    // The background color, a CSS color string.
    color: "white",

    // The string that gets displayed in the center of the box.
    text: "",

    // The width in pixels of lines for the X.
    lineWidth: 8

  });

  // Expose a div element that will be added to the Chiasm container.
  // This is a special property that Chiasm looks for after components are constructed.
  my.el = document.createElement("div");

  // Construct the SVG DOM.
  var svg = d3.select(my.el).append("svg");

  // Add a background rectangle to the SVG.
  // The location of the rect will be fixed at (0, 0)
  // with respect to the containing SVG.
  svg.append("rect")
    .attr("x", 0)
    .attr("y", 0);

  // Add a text element to the SVG,
  // which will render the `text` my property.
  svg.append("text")
    .attr("font-size", "7em")
    .attr("text-anchor", "middle")
    .attr("alignment-baseline", "middle");

  // Update the color and text based on the my.
  my.when("color", function (color){
    svg.select("rect").attr("fill", color);
  });

  // Update the text.
  my.when("text", function (text){
    svg.select("text").text(text);
  });

  // When the size of the visualization is set
  // by the chiasm layout engine,
  my.when("box", function (box) {

    // Set the size of the SVG.
    svg
      .attr("width", box.width)
      .attr("height", box.height);

    // Set the size of the background rectangle.
    svg.select("rect")
      .attr("width", box.width)
      .attr("height", box.height);

    // Update the text label to be centered.
    svg.select("text")
      .attr("x", box.width / 2)
      .attr("y", box.height / 2);

  });

  // Update the X lines whenever either
  // the `box` or `lineWidth` my properties change.
  my.when(["box", "lineWidth"], function (box, lineWidth) {
    var w = box.width,
        h = box.height,
        lines = svg.selectAll("line").data([
          {x1: 0, y1: 0, x2: w, y2: h},
          {x1: 0, y1: h, x2: w, y2: 0}
        ]);
    lines.enter().append("line");
    lines
      .attr("x1", function (d) { return d.x1; })
      .attr("y1", function (d) { return d.y1; })
      .attr("x2", function (d) { return d.x2; })
      .attr("y2", function (d) { return d.y2; })
      .style("stroke-width", lineWidth)
      .style("stroke-opacity", 0.2)
      .style("stroke", "black")
      .call(lineDrag);
  });

  // Make the X lines draggable. This shows how to add interaction to
  // visualization modules.  Dragging updates the `lineWidth` property.
  var lineDrag = (function () {
    var x1, x2;
    return d3.behavior.drag()
      .on("dragstart", function (d) {
        x1 = d3.event.sourceEvent.pageX;
      })
      .on("drag", function (d) {
        var x2 = d3.event.sourceEvent.pageX,
            newLineWidth = my.lineWidth + x2 - x1;

        // Enforce minimum line width of 1 pixel.
        newLineWidth = newLineWidth < 1 ? 1 : newLineWidth;

        // Set the lineWidth property on the component.
        // This change will be propagated into the Chiasm configuration.
        my.lineWidth = newLineWidth;

        x1 = x2;
      });
  }());

  return my;
}
