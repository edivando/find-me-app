//
//  ViewController.m
//  FindMeApp
//
//  Created by bepid on 26/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "ViewController.h"
#import "GoogleMaps/GoogleMaps.h"



@interface ViewController ()
{
    //GMSMapView *mapView_;
    
}
@end

@implementation ViewController{
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    WebSocket *socket;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    socket = [WebSocketSingleton getConnection];
    manager = [[CLLocationManager alloc] init];
    _UsuariosAtivos = [NSMutableArray new];
    
    UserInfo* user1 = [[UserInfo alloc] initWithUser:@"Diego" latitude:10.000 longitude:78.987 email:@"diegovidal08@gmail.com" telefone:@"85251091" idServer:0 connectionId:0];
    
    UserInfo* user2 = [[UserInfo alloc] initWithUser:@"Diego2" latitude:60.000 longitude:78.987 email:@"diegovidal08@gmail.com" telefone:@"85251091" idServer:0 connectionId:0];
    
    UserInfo* user3 = [[UserInfo alloc] initWithUser:@"Diego3" latitude:30.000 longitude:78.987 email:@"diegovidal08@gmail.com" telefone:@"85251091" idServer:0 connectionId:0];
    
    [_UsuariosAtivos addObjectsFromArray:(@[user1,user2,user3])];
    
    _latitude = 0.0;
    _longitude = 0.0;
    
    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    //[self Indoor];
    
    

}

-(void) viewDidAppear:(BOOL)animated{
    UserInfoDAO *dao = [[UserInfoDAO alloc] init];
    NSArray *users = [dao fetchWithKey:@"defaultuser" andValue:@"YES"];
    //Testa se existe usuário registrado no BD
    if ([users count] == 0) {
        //Se não existir, carrega view registro
        [self performSegueWithIdentifier:@"SegueViewRegistro" sender:nil];
    }
    else{
        UserInfoMessage *message = [[UserInfoMessage alloc] initWithUser:[users objectAtIndex:0]];
        [socket sendMessage:[message toJSONString]];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) HelloMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_latitude
                                                            longitude:_longitude
                                                                 zoom:6];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    marker.snippet = @"Hello World";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = mapView;

    
    self.view = mapView;
}

-(void) ChangeTheMapType{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.80948
                                                            longitude:5.965699
                                                                 zoom:2];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    // Available map types: kGMSTypeNormal, kGMSTypeSatellite, kGMSTypeHybrid,
    // kGMSTypeTerrain, kGMSTypeNone
    
    // Set the mapType to Satellite
    mapView.mapType = kGMSTypeSatellite;
    self.view = mapView;
    
}

-(void) CustomMaker{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:41.887
                                                            longitude:-87.622
                                                                 zoom:18];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(41.887, -87.622);
//    marker.appearAnimation = kGMSMarkerAnimationPop;
//    marker.icon = [UIImage imageNamed:@"flag_icon"];
//    marker.map = mapView;
//    
//    GMSMarker *marker2 = [[GMSMarker alloc] init];
//    marker2.position = CLLocationCoordinate2DMake(41.880, -87.622);
//    marker2.appearAnimation = kGMSMarkerAnimationPop;
//    //marker2.icon = [UIImage imageNamed:@"flag_icon"];
//    marker2.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
//    marker2.map = mapView;
    
//    for (UserInfo* user in _UsuariosAtivos) {
//        user.marker.map = mapView;
//    }
    
    //mapView.mapType = kGMSTypeSatellite;

    
    self.view = mapView;

}

-(void) StreetView{
    CLLocationCoordinate2D panoramaNear = {_latitude,_longitude};
    
    GMSPanoramaView *panoView =
    [GMSPanoramaView panoramaWithFrame:CGRectZero
                        nearCoordinate:panoramaNear];
    
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(41.887, -87.622);
//    marker.appearAnimation = kGMSMarkerAnimationPop;
//    marker.icon = [UIImage imageNamed:@"flag_icon"];
//    marker.panoramaView = panoView;
//    
//    GMSMarker *marker2 = [[GMSMarker alloc] init];
//    marker2.position = CLLocationCoordinate2DMake(41.880, -87.622);
//    marker2.appearAnimation = kGMSMarkerAnimationPop;
//    //marker2.icon = [UIImage imageNamed:@"flag_icon"];
//    marker2.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
//    marker2.panoramaView = panoView;
    
    self.view = panoView;
}

-(void) PolyLines{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0
                                                            longitude:-165
                                                                 zoom:2];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    GMSMutablePath *path = [GMSMutablePath path];
    [path addLatitude:-33.866 longitude:151.195]; // Sydney
    [path addLatitude:-18.142 longitude:178.431]; // Fiji
    [path addLatitude:21.291 longitude:-157.821]; // Hawaii
    [path addLatitude:37.423 longitude:-122.091]; // Mountain View
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blueColor];
    polyline.strokeWidth = 5.f;
    polyline.map = mapView;

}

-(void) Camera{
    GMSCameraPosition *camera =
    [GMSCameraPosition cameraWithLatitude:-37.809487
                                longitude:144.965699
                                     zoom:17.5
                                  bearing:30
                             viewingAngle:40];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = mapView;
}

-(void) Indoor{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.78318
                                                            longitude:-122.40374
                                                                 zoom:18];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = mapView;
    
}

-(void) MyLocation{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:12];
    GMSMapView *mapView_;
    
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    
    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    self.view = mapView_;

    
}

-(void) exampleMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    GMSMapView *mapView;

    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView;
    
    self.view = mapView;


}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location! :(");
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Distance Location: %f", [newLocation distanceFromLocation:oldLocation]);
    CLLocation *currentLocation = newLocation;

    if (currentLocation != nil) {
        
        _latitude = currentLocation.coordinate.latitude;
        _longitude = currentLocation.coordinate.longitude;
        
        [self StreetView];
        
        //NSLog(@"%f", currentLocation.coordinate.latitude);
        
//        NSLog(@"%@\n",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
//        NSLog(@"%@\n",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
//        NSLog(@"Pega Latitude e Longitude");
        
        [self mandaLocalização];
        
        
    }
    
//    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        
//        if (error == nil && [placemarks count] > 0) {
//            
//            placemark = [placemarks lastObject];
//            
//           NSLog(@"%@",[NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
//                                 placemark.subThoroughfare, placemark.thoroughfare,
//                                 placemark.postalCode, placemark.locality,
//                                 placemark.administrativeArea,
//                                 placemark.country]);
//           NSLog(@"Pega Adress");
//            
//        } else {
//            
//            NSLog(@"%@", error.debugDescription);
//            
//        }
//        
//    } ];
    
    
}

#pragma mark - ButtonAction

- (IBAction)getLocation:(UIButton *)sender {
    
    manager.delegate = self;
   // manager.desiredAccuracy = kCLLocationAccuracyBest;
    //manager.distanceFilter = 10.0;
    //manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //[manager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //[manager setDistanceFilter:kCLDistanceFilterNone];
    //manager.distanceFilter = 50.0f;
    //manager.headingFilter = 5;
    //[manager startUpdatingLocation];
    
    
    
    manager.distanceFilter = 10.0;
    manager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m

    

    // update location
    if ([CLLocationManager locationServicesEnabled]){
        [manager startUpdatingLocation];
    }
}

-(void) mandaLocalização{
//    UserInfo *position = [[UserInfo alloc]initWithUser:@"Yuri BlaBla" latitude:_latitude longitude:_longitude email:@"bla@bla.com" telefone:@"35699856"];
//    
//    NSLog(@"JSON STRING:\n%@",[position toJSONString]);
//    
//    [socket sendMessage:[position toJSONString]];
//    
//    
    //{userInfo"{"email":"bla@bla.com","telefone":"35699856","latitude":37.33241,"longitude":-122.0305,"user":"Yuri BlaBla"}}
}

-(void) markerTest{
    
    GMSMapView *mapView;
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(51.5, -0.127);
    GMSMarker *london = [GMSMarker markerWithPosition:position];
    london.title = @"London";
    london.snippet = @"Population: 8,174,100";
    london.infoWindowAnchor = CGPointMake(0.5, 0.5);
    london.icon = [UIImage imageNamed:@"house"];
    london.map = mapView;
    
    self.view = mapView;


}


@end
