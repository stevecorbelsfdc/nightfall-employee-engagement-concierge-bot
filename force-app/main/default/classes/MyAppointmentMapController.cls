public class MyAppointmentMapController {
    
    public MyAppointmentMapController(){}
    
    
    
    
    public static gogoApptGeoJson.Feature newFeature(String id, String Name, String description, String iconurl, Decimal lon, Decimal lat, String symbol, String color, String gogotype){
        
        
        gogoApptGeoJson.Feature feat = new gogoApptGeoJson.Feature();
        feat.id = id;
        feat.iconurl = iconurl;
        gogoApptGeoJson.Geometry geo = new gogoApptGeoJson.Geometry();
        
        geo.coordinates = new Double[]{ lon, lat};
        feat.geometry = geo;
        gogoApptGeoJson.Property prop = new gogoApptGeoJson.Property();
        prop.title = Name;
        prop.description = description;
        prop.marker_symbol = symbol;
        //  prop.marker_color = '#0c1';
        prop.marker_color = '#0c1';
        prop.marker_size = 'large';
        prop.gogotype = gogotype;
        feat.properties = prop;
        
        return feat;
    }
    
    
    @AuraEnabled
    public static gogoApptGeoJson.FeatureCollection myAppointment(String UserId){
        //ID Userid = Userinfo.getUserId();
        //userId = UserInfo.getUserId();
        //
        gogoApptGeoJson.FeatureCollection fc = new gogoApptGeoJson.FeatureCollection();
        List<Account> al = [Select id, name, billinglongitude, billinglatitude from account where billinglongitude != null and billinglatitude != null LIMIT 2];
        
        List<gogoApptGeoJson.Feature> feats = new List<gogoApptGeoJson.Feature>();
        
        for(Account a: al){
        gogoApptGeoJson.Feature servicer = newFeature(a.Id, a.Name, a.Name , '/img/icon/serviceResource32.png' ,a.BillingLongitude, a.BillingLatitude, 'building', '#f44', 'ServiceResource');            
        feats.add(servicer);  
        }
        //  gogoApptGeoJson.Feature home = newFeature(sa.Id, 'Appointment Location', 'Appointment Location' , '/img/icon/serviceAppointment32.png' ,saad.getlongitude(), saad.getlatitude(), 'building', '#f44', 'ServiceAppointment');                
        
        //  feats.add(home);
        
        
        
        fc.features = feats;
        
        return fc;
    }
    
    
    
    
}