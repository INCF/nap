
library ExperimentViewController;

import 'dart:html';
import 'dart:math' as math;

import "package:rikulo_commons/util.dart";
import 'package:rikulo/view.dart';
import 'package:rikulo/html.dart';
import 'package:rikulo/gesture.dart';
import 'package:rikulo/event.dart';

import 'package:js/js.dart' as js;


class ExperimentViewController {
  
  View contentView;
  TextView experimentNameLabel;
  TextView extendedFromLabel;
  TextView createdDate;
  
  ExperimentViewController()
  {
    print('Initialized EVC');
    
    contentView = new View();
    
    contentView.profile.text = "location: left top;";
    contentView.profile.width = "flex";
//    contentView.profile.height = "content";
    contentView.profile.spacing = "10px";
    contentView.classes.add("experimentView");
    contentView.style.cssText = 'background:#eee;';
    contentView.layout.type = "linear";
    contentView.layout.orient = "vertical";
    
//    TextView staticExperimentLabel = new TextView.fromHtml('<h3>Experiment : </h3>');
    TextView staticExperimentLabel = new TextView('Experiment: ');
    staticExperimentLabel.style.cssText = 'font-weight:700; padding-left:4px';
//    staticExperimentLabel.height = 30;
//    staticExperimentLabel.style.cssText = 'background:#ccc';
    contentView.addChild(staticExperimentLabel);
    
    this.experimentNameLabel = new TextView('MRI Image Quality Control');
    this.experimentNameLabel.style.cssText = 'font-weight:400; padding-left:4px';
    this.experimentNameLabel.profile.width = 'flex';
//    this.experimentNameLabel.height = 30;
    contentView.addChild(this.experimentNameLabel);
    
    this.extendedFromLabel = new TextView('Extended from MRI Image Query Template');
//    this.extendedFromLabel.height = 30;
    this.extendedFromLabel.style.cssText = 'font-weight:400; padding-left:4px';

    contentView.addChild(this.extendedFromLabel);
    
    
    Button btn = new Button('Perform action');    
    btn.on.click.add((event) {
      executeD3Test();
    });
    
    contentView.addChild(btn);
    contentView.requestLayout();
    
    
    
    
//    for (final String type in
//        ["text", "password", "multiline", "number", "date", "color"]) {
//      View view = new View();
//      view.layout.text = "type: linear; align: center; spacing: 0 3";
//      //top and bottom: 0 since nested
//      contentView.addChild(view);
//    
//      TextView label = new TextView(type);
//      label.style.textAlign = "right";
//      label.profile.width = "70";
//      view.addChild(label);
//    
//      view.addChild(type == "multiline" ? new TextArea(): new TextBox(null, type));
//    }
    
  }
  
  void executeD3Test()
  {
    
    js.scoped(() {
      
      
      var dee3 = js.context.d3; 
      var dataset = js.array([ 5, 10, 15, 20, 25 ]);
      dee3.select("#example").selectAll("p")
      .data(dataset)
      .enter()
      .append("p")
      .text(new js.Callback.many((d, i, context) { return d; }));
      
      
      
    });
  
  }
   
}

//    var googlemap;

//    js.scoped(() {
//      var dee3 = js.context.d3;
//
      
//      
      
//      
//      var parcoodel = dee3.parcoords();
//      
//      js.context.console.log(dataset);
      
      
      
//      var newPC = pc('#example').data()
//                                       ..render()
//                                       ..createAxes();
//      
//      print(newPC);
      
//      js.proxyDebug();
      
//      var sampleSVG = dee3.select("#example")
//          .append("svg")
//          .attr("width", 100)
//          .attr("height", 100);    
//
//      sampleSVG.append("circle")
//      .style("stroke", "gray")
//      .style("fill", "white")
//      .attr("r", 40)
//      .attr("cx", 50)
//      .attr("cy", 50);
      
      
      
      
      
      
//      
//      var dee3pc = js.context.d3.parcoords;
//      

//      var pc = dee3pc('#example');
//      
//      pc.data(dataset);
//      pc.render();
//      
      
//    });
//      var pc = d3.parcoords()("#example").data([
//               .render()
//               .createAxes();
//      
////      var canvas = query('#map_canvas');
////      var googlemaps = js.context.google.maps;
////      googlemap = new js.Proxy(googlemaps.Map, canvas);
////      js.retain(googlemap);
