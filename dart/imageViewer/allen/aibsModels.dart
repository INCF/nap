
library aibsModels;

import 'dart:html';
import 'dart:json';


class AIBSImage {

  ///the unique identifier for this particular image 
  num aibsID;
  
  ///the unique identifer for dataset this image belongs to
  num dataSetID;
  
  String expressionPath;
  String imagePath;
  
  num imageWidth;
  num imageHeight;
  num resolution;
  num sectionNumber;
  num structureID; 
  num tierCount; // number of zoomable levels
  
  String queryURL;
  
  String imageServerBaseURL = 'http://human.brain-map.org/tiles//';
  String zoomifyThumbnailBase = '/TileGroup/0-0-0.jpg';
  
  
  String getSubImageParameters()
  {
    return '?siTop=0&siLeft=0&siWidth=${this.imageWidth}&siHeight=${this.imageHeight}';
    
//    ?siTop=0&siLeft=0&siWidth=19744&siHeight=46880
  }
  
  
  
//      http://human.brain-map.org/tiles///external/humanctx/production30/stitch6/0400057357/0400057357_1_zoom.aff/TileGroup/0-0-0.jpg?siTop=0&siLeft=0&siWidth=19744&siHeight=46880
      
  void printImageDetails()
  {
    print('''Details for ${this.dataSetID} : ${this.aibsID}
    Path: ${this.imagePath}
    Image properties: ${this.imageWidth} x ${this.imageHeight}
    Tiers: ${this.tierCount}
    Section: ${this.sectionNumber}
     ''');
     
    print(this.getImageThumbnail());
    
  }
  
  String getImageThumbnail()
  {
      return '${this.imageServerBaseURL}${this.imagePath}${this.zoomifyThumbnailBase}${this.getSubImageParameters()}';
      
  }
  
//  void fetchSubjectDetails(){
//    
//    this.queryURL = '''http://connectivity.brain-map.org/api/v2/data/SectionDataSet/${this.aibsID}.json?wrap=true&include=plane_of_section%2Ctreatments%2Cspecimen(donor(transgenic_mouse(transgenic_lines))%2Cinjections(structure%2Cage))%2Csection_images(associates)%2Cgenes%2Cequalization&order=sub_images.section_number%24desc''';
//    print(this.queryURL);
//    var request = new HttpRequest.get(this.queryURL, this.onSuccess);
//  }
//  
//
//  void onSuccess(HttpRequest req)
//  {
//
//    // parse 
//    Map parsedMap = JSON.parse(req.responseText);
//    int numberOfResults = parsedMap['total_rows'];
//    print('There are $numberOfResults results for the AIBS image settings query.');
//    
//    List responseList = parsedMap['msg'];
//    
//    print(responseList.length);
//        
//    
//  }
  
}



/**
 * Provides a schema for AIBS probes
 */
class AIBSProbe { 
  
  /** Association name
   */
  num arAssociationKeyName;
  
  String fluor_color;
  
  num forwardSequenceID;
  num reverseSequenceID;
  
  num geneID;
  num probeID;
  
  String label;
  String name;
  String ncbiAccessionNumber;
  String probeType;
  
  
  
}

class AIBSGene
{
  
  num geneID;
  
  String acronym;
  String aliasTags;
  
  num chromosomeID;
  
  String ensembleID;
  num entrezID;
  num hologeneID;
  
  String name;
  num organismID;
  num sphinxID;
  
}