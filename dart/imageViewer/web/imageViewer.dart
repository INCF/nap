import 'dart:html';
import 'dart:math' as math;

import "package:rikulo_commons/util.dart";
import 'package:rikulo/view.dart';
import 'package:rikulo/html.dart';
import 'package:rikulo/gesture.dart';
import 'package:rikulo/event.dart';

import '../allen/aibsModels.dart' as aibs;
import '../allen/ImageCollection.dart';

import 'experimentViewController.dart';

import 'Viewport.dart';

import '../nidm.dart';


var imageCollection;

View mainView;
Viewport viewport;
ScrollView scrollView;
ExperimentViewController experimentView;


//Image img;

void main() {

  
//  createExperimentView();
//  createInnerViews(viewport);
  
//  
  imageCollection = new ImageCollection('Example init message passing', hasImageData);
  imageCollection.queryJSONFromAIBS();
//  
//  scrollView = new ScrollView(direction: Dir.VERTICAL, 
//  snap: (Offset off) {
//    final num vlimit = 50 * 50 - scrollView.innerHeight;
//    final num y = off.y >= vlimit ? vlimit : ((off.y + 25) / 50).floor() * 50;
//    return new Offset(off.x, y);
//  });
//  scrollView.profile.text = "location: right top; width: 250px; height: 250px";
//  scrollView.classes.add("list-view");
//  
  mainView = new View();
  mainView.addToDocument();
  
  createViewport();
  createExperimentView();
  
  Nidm dm = new Nidm();
//  dm.queryConstruct();
//  dm.queryDefault();
  
//  viewport.addChild(scrollView);
//  viewport.contentNode = scrollView;

//  final View mainView = new View()..addToDocument();
//  mainView.addChild(scrollView);
//  
  

  
}

void createViewport()
{
  viewport = new Viewport('NIDASH');
  viewport.layout.type = "linear";
  viewport.layout.orient = "vertical";
  viewport.profile.width = viewport.profile.height = "flex";
  
//  createToolbar(viewport);
  
  mainView.addChild(viewport);
}


void createExperimentView()
{
  experimentView = new ExperimentViewController();
  
  viewport.addChild(experimentView.contentView);
  
  View parCor = new View.html('''<div id="example" class="parcoords" style="width:500px;height:150px"></div>''');
  parCor.profile.width = '500px';
  parCor.profile.height = '250px';
  parCor.style.background = "#ccc";
  
  experimentView.contentView.addChild(parCor);
  
  
  
  
//  viewport.addChild(experimentView.contentView);
//  viewport.requestLayout(false, false);
}


//void createExperimentView()
//{
//    experimentView = new View();
//    experimentView.style.cssText = "background:#fff";
//    experimentView.width = 256;
//    experimentView.height = 256;
//    
//    img = new Image();
////     http://www.flickr.com/photos/normanbleventhalmapcenter/2675391188/
//    // Creative Commons License
//    img.src = "http://static.rikulo.org/blogs/tutorial/zoom-map/res/dutch-west-india-company-map.jpg";
//    img.profile.text = "location: center center";
//    
//    experimentView.addChild(img);
//    
//    img.node.draggable = false;
//    
//    Offset diff;
//    Transformation trans;
//    
//    // sizing
//    img.on.preLayout.add((event) {
//      Size psize = new DomAgent(experimentView.node).innerSize;
//      if (psize.width / experimentView.width < psize.height / experimentView.height) {
//        img.width = psize.width.toInt();
//        img.height = psize.width * experimentView.height ~/ experimentView.width;
//      } else {
//        img.width = psize.height * experimentView.width ~/ experimentView.height;
//        img.height = psize.height.toInt();
//      }
//      trans = new Transformation.identity();
//      img.style.transform = Css.transform(trans);
//      
//    });
//    
//    new ZoomGesture(experimentView.node, start: (ZoomGestureState state) {
//      diff = center(img) - state.startMidpoint;
//      
//    }, move: (ZoomGestureState state) {
//      img.style.transform = Css.transform(state.transformation.originAt(diff) * trans);
//      
//    }, end: (ZoomGestureState state) {
//      trans = state.transformation.originAt(diff) * trans;
//      
//    });
//    
//    new DragGesture(experimentView.node, move: (DragGestureState state) {
//      img.style.transform = Css.transform(new Transformation.transit(state.transition) * trans);
//      
//    }, end: (DragGestureState state) {
//      trans = new Transformation.transit(state.transition) * trans;
//      
//    });
//    
//    viewport.addChild(experimentView);
//    
//}


void hasImageData()
{
//  int x = 0;  
//    for(var imageInfo in imageCollection.imageSeriesList)
//    {
//      
//      View child = new TextView("${imageInfo.aibsID}");
//      
//      final int height = 30;
//      child.classes.add("list-item");
//      child.style.cssText = "line-height: ${height}px";
//      child.profile.width = "flex";
//      
//      child.top = x * height;
//      child.height = height;
//      child.on.click.add(selectRowWithPath);
//      
//      scrollView.addChild(child);
//      ++x;
//  } 
//  scrollView.requestLayout(true, false);
}

void selectRowWithPath(event)
{  
  TextView tv = event.target;
  String imageID = tv.text;
//  print();
  
  aibs.AIBSImage imageInfo = imageCollection.getByID(math.parseInt(imageID));
  
  img.src = imageInfo.getImageThumbnail(); 
  
}

void displayResult(Event event) {
    
//  imageCollection.printImageList();


//  for (int x = 0; x < 50; ++x) {
//    View child = new TextView("Row ${x + 1}");
//      
//    final int height = 50;
//    child.classes.add("list-item");
//    child.style.cssText = "line-height: ${height}px";
//    child.profile.width = "flex";
//    child.top = x * height;
//    child.height = height;
//    
//    view.addChild(child);
//  }
   
}

void createToolbar(Viewport parent) {
  View toolbar = new View();
  
  toolbar.layout.type = "linear";
  toolbar.profile.width = "content"; // or flex
  toolbar.profile.height = "content";
//  toolbar.layout.align 
//  toolbar.style.backgroundColor = "#fff";
  
  num i = 0;
  for (final String src in ["01-refresh.png", "06-magnify.png", "07-map-marker.png"]) {
    
    Image imgToAdd = new Image("res/icons/icons-white/$src");
    imgToAdd.dataAttributes['test'] = i;
    imgToAdd.on.click.add(buttonTapHandler);
    toolbar.addChild(imgToAdd);
    i++;
  }
  parent.toolbar = toolbar;
}

void createInnerViews(Viewport parent)
{
//second horizontal layout
  View hlayout = new View();
  hlayout.layout.type = "linear";
//  hlayout.layout.align = "end";
  hlayout.profile.height = "flex";
  hlayout.profile.width = "flex";
//  hlayout.
  parent.addChild(hlayout);

  View view = new View();
  view.style.backgroundColor = "#fff";
  view.profile.width = "350";
  view.profile.height = "flex";
  view.style.padding = "0px";
  view.style.margin = "0px";
  
  hlayout.addChild(view);
  view = new View();
  view.style.backgroundColor = "#fff";
  view.profile.width = "flex";
  view.profile.height = "50%";
  hlayout.addChild(view);
//  view = new View();
//  view.style.backgroundColor = "blue";
//  view.profile.width = "flex 1";
//  view.profile.height = "25%";
//  hlayout.addChild(view);
}

void buttonTapHandler(event)
{
  print(event);
  
//  print(event);
}
