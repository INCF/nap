library nidm;

import 'dart:html';
import 'dart:json';
import 'dart:uri';

import 'package:html5lib/parser.dart' show parse;
import 'package:html5lib/dom.dart';


class ResponseFormat{
  static const String sparqlXML = 'application/sparql-results+xml';
  static const String sparqlJSON = 'application/sparql-results+json';
  static const String rdfXML = 'application/rdf+xml';
  static const String rdfJSON = 'application/rdf+json';
  static const String rdfN3 = 'text/rdf+n3';
  static const String Html = 'text/html';
}

class Subject
{
  String id;
  num age;
  String gender;
  bool isRightHanded;
  
  void printSummary()
  {
    print('${id} - ${age}, ${gender}, ${isRightHanded}');
  }
}

class Nidm {

  final String sparqlEndpoint = 'http://ec2-50-112-226-149.us-west-2.compute.amazonaws.com:8890/sparql';
  //  debug post server
  //  final String sparqlEndpoint = 'http://posttestserver.com/post.php';
  
  final String defaultIRI = 'http://nidm.nidash.org/nitrc-ir';
  
  List subjectList = new List<Subject>();
  
      // constructor
  Nidm(){
    print('Initialized NiDm');
  }
  
  // public members
  void queryDefault()
  {
    String query = '''
        PREFIX xsd:  <http://www.w3.org/2001/XMLSchema#>
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        PREFIX nidm: <http://ibic.washington.edu/nidm#>
        PREFIX prov: <http://www.w3.org/ns/prov#>

        SELECT ?id ?age ?gender ?handedness
        
        WHERE {?subject_uri a prov:Agent .
        ?subject_uri rdfs:label ?id .
        ?subject_uri nidm:age ?age_link .
        ?age_link prov:value ?age .
        ?subject_uri nidm:gender ?gender .
        ?subject_uri nidm:handedness ?handedness .
        
        FILTER (xsd:integer(?age) < 18) .
        FILTER (?handedness = "right") .}''';
    
    this._queryEndpoint(query);
    
  }
  
  void queryConstruct()
  {
    String query = '''
       PREFIX xsd:    <http://www.w3.org/2001/XMLSchema#>
       PREFIX rdfs:     <http://www.w3.org/2000/01/rdf-schema#>
       PREFIX nidm:  <http://ibic.washington.edu/nidm#>
       PREFIX prov:   <http://www.w3.org/ns/prov#>

       CONSTRUCT {?subject_uri a prov:Agent .
             ?subject_uri rdfs:label ?id .
             ?subject_uri nidm:age ?age_link .
             ?age_link prov:value ?age .
             ?subject_uri nidm:gender ?gender .
             ?subject_uri nidm:handedness ?handedness .}

       WHERE {?subject_uri a prov:Agent .
             ?subject_uri rdfs:label ?id .
             ?subject_uri nidm:age ?age_link .
             ?age_link prov:value ?age .
             ?subject_uri nidm:gender ?gender .
             ?subject_uri nidm:handedness ?handedness .
             FILTER (xsd:integer(?age) < 18) .
             FILTER (?handedness = "right") .}''';
    
    this._queryEndpoint(query);
    
  }
  
  
  
  
  
  
  // private members
  
  String _encodeMap(Map data) {
    return Strings.join(data.keys.map((k) {
      return '${encodeUriComponent(k)}=${encodeUriComponent(data[k])}';
    }), '&');
  }
  
  void _queryEndpoint(String queryString)
  {
    HttpRequest req = new HttpRequest(); // create a new XHR

    // add an event handler that is called when the request finishes
    req.on.readyStateChange.add((Event e) {
      if (req.readyState == HttpRequest.DONE && (req.status == 200 || req.status == 0)) {
        this._onSuccess(req); // called when the POST successfully completes
      }
      else
      {
        
      }
    });
    
    // creates connection with credentials, async
    req.open('POST', this.sparqlEndpoint, true, 'nidash', 'nidash');

    // needed to move post data into parameters
    req.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

    // set return format here
    req.setRequestHeader('Accept', ResponseFormat.sparqlJSON);
    
    var data = {'query': '${queryString}' };
    var encodedData = _encodeMap(data);

    // kick off the request to the server
    req.send(encodedData); 
  }
  
  void _queryEndpointWithFormat(String queryString, String responseFormat)
  {
    HttpRequest req = new HttpRequest(); // create a new XHR

    // add an event handler that is called when the request finishes
    req.on.readyStateChange.add((Event e) {
      if (req.readyState == HttpRequest.DONE && (req.status == 200 || req.status == 0)) {
        this._onSuccess(req); // called when the POST successfully completes
      }
      else
      {
        
      }
    });
    
    // creates connection with credentials, async
    req.open('POST', this.sparqlEndpoint, true, 'nidash', 'nidash');

    // needed to move post data into parameters
    req.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

    // set return format here
    req.setRequestHeader('Accept', responseFormat);
    
    var data = {'query': '${queryString}' };
    var encodedData = _encodeMap(data);

    // kick off the request to the server
    req.send(encodedData); 
  }
  
  void _onSuccess(HttpRequest req) {
//    print(req.responseText); // print the received raw text
    Map data = JSON.parse(req.responseText); // parse response text

    var head = data['head'];
    var result = data['results'];
    
    if(result is Map)
    {
      
//      print(result.keys.toString()); [distinct, ordered, bindings]
//      print(result['bindings'].length); // 6528
//      print(result['distinct']); // false
//      print(result['ordered']); // true
      
//      { "id": { "type": "literal", "value": "xnat_S02638" } , "age": { "type": "literal", "value": "6" }  , "gender": { "type": "literal", "value": "male" }  , "handedness": { "type": "literal", "value": "right" }},

      List entities = result['bindings'];
      
      for(Map entity in entities)
      {
        
         Subject s = new Subject();
         s.id = entity['id']['value'];
         s.age = int.parse(entity['age']['value']);
         s.gender = entity['gender']['value'];
         
         if(entity['handedness']['value'] == 'right')
         {
           s.isRightHanded = true;
         }
         else
         {
           s.isRightHanded = false;
         }
         
         this.subjectList.add(s);
      }
      
    }
  }

  
  
  
  
//  void runSampleRequest()
//  {
//    HttpRequest req = new HttpRequest(); // create a new XHR
//
//    // add an event handler that is called when the request finishes
//    req.on.readyStateChange.add((Event e) {
//      if (req.readyState == HttpRequest.DONE && (req.status == 200 || req.status == 0)) {
//        this.onSuccess(req); // called when the POST successfully completes
//      }
//      else
//      {
//        
//      }
//    });
//    
//    // creates connection with credentials, async
//    req.open('POST', this.sparqlEndpoint, true, 'nidash', 'nidash');
//
//    // needed to move post data into parameters
//    req.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
//
//    // set return format here
//    req.setRequestHeader('Accept', 'text/html');
//    
//    String query = '''
//      PREFIX xsd:    <http://www.w3.org/2001/XMLSchema#>
//      PREFIX rdfs:     <http://www.w3.org/2000/01/rdf-schema#>
//      PREFIX nidm:  <http://ibic.washington.edu/nidm#>
//      PREFIX prov:   <http://www.w3.org/ns/prov#>
//
//      SELECT ?id ?age ?gender ?handedness
//      
//      WHERE {?subject_uri a prov:Agent .
//       ?subject_uri rdfs:label ?id .
//       ?subject_uri nidm:age ?age_link .
//       ?age_link prov:value ?age .
//       ?subject_uri nidm:gender ?gender .
//       ?subject_uri nidm:handedness ?handedness .
//      
//      FILTER (xsd:integer(?age) < 18) .
//      FILTER (?handedness = "right") .}''';
//
//    var data = {'query': '${query}' };
//    var encodedData = encodeMap(data);
//
//    // kick off the request to the server
//    req.send(encodedData); 
//  }
//  
  
  
  
}
