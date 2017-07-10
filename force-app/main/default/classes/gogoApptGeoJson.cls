global  class gogoApptGeoJson {

      
    global class FeatureCollection{
   @AuraEnabled  global String type='FeatureCollection';
   @AuraEnabled  global List<Feature> features;
    }
    

    global class Feature {
     @AuraEnabled    global  String type = 'Feature';
     @AuraEnabled    global  Geometry geometry;
     @AuraEnabled    global Property properties;
     @AuraEnabled    global String id;
     @AuraEnabled global String iconurl;
    }

    global class Geometry {
    
     @AuraEnabled    global String type='Point';
     @AuraEnabled    global Double[] coordinates;
    }

    global class Property {
     @AuraEnabled    global String title;
      @AuraEnabled   global String description;
      @AuraEnabled   global String marker_color;
      @AuraEnabled   global String marker_size;
      @AuraEnabled   global String marker_symbol;
      @AuraEnabled   global String gogotype;
        
    }
}