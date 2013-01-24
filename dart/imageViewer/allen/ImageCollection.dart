library ImageCollection;

import 'dart:html';
import 'dart:json';


import 'aibsModels.dart' as aibs;


class ImageCollection {
  
  List imageSeriesList;
  var delegate;
  
  ImageCollection(String customMessage, var delegate)
  {
    print("Initialized new Neurokit class with note: $customMessage");
    this.imageSeriesList = new List<aibs.AIBSImage>();
    this.delegate = delegate;
  }
  
  final String queryURL = '''http://api.brain-map.org/api/v2/data/query.json?'''
      '''criteria=model::SectionDataSet,'''
      '''rma::criteria,products[abbreviation\$in'HumanASD','HumanCtx','HumanSubCtx','HumanSZ','HumanNT'],'''
      '''treatments[name\$eq'ISH'],specimen[donor_id\$eq1312],'''
      '''rma::include,probes(gene),section_images,specimen(donor(age,disease_categories,medical_conditions))''';
  

  bool queryJSONFromAIBS () {
    
    var request = new HttpRequest.get(this.queryURL, this.onSuccess);
    return true;
    
  }


  void onSuccess(HttpRequest req)
  {

    print("Success");
    // parse 
    Map parsedMap = JSON.parse(req.responseText);
    int numberOfResults = parsedMap['total_rows'];
    print('There are $numberOfResults results for the AIBS api query.');
    
    List responseList = parsedMap['msg'];
    
    print(responseList.length);
    
    
    for(int _id =0; _id< responseList.length; _id++)
    {
      Map sds = responseList[_id];

      List listOfImages = sds['section_images'];
      
      for(Map imageDetails in listOfImages)
      {
        var imageToAdd = new aibs.AIBSImage();
        imageToAdd.imageHeight = imageDetails['image_height'];
        imageToAdd.imageWidth = imageDetails['image_width'];
        imageToAdd.imagePath = imageDetails['path'];
        imageToAdd.expressionPath = imageDetails['expressionPath'];
        imageToAdd.resolution = imageDetails['resolution'];
        imageToAdd.structureID = imageDetails['structure_id'];
        imageToAdd.sectionNumber = imageDetails['section_number'];
        imageToAdd.aibsID = imageDetails['id'];
        imageToAdd.tierCount = imageDetails['tier_count'];
        imageToAdd.dataSetID = imageDetails['data_set_id'];
        
        this.imageSeriesList.add(imageToAdd);
        
      }      
  
    }
    
    this.delegate();

  }
  
  void printImageList()
  {
    for(var imageInfo in this.imageSeriesList)
    {
      
      imageInfo.printImageDetails();
      
    }
  }
  
  aibs.AIBSImage getByID(num idString)
  {
    for(var imageInfo in this.imageSeriesList)
    {
      if(imageInfo.aibsID == idString ) 
      {
//        imageInfo.printImageDetails();
        return imageInfo;
      }
      
    }
  }
  
}
