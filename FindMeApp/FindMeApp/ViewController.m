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
    UserInfoDAO *dao;
    
    NSTimer *timer;
    NSTimeInterval intervalo;
    
    int count;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Limpando todos os usuários, menos o default do bd
    dao = [[UserInfoDAO alloc] init];
    [dao clearAllExceptDefault];
    
    socket = [WebSocketSingleton getConnection];
    manager = [[CLLocationManager alloc] init];
    
    //manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    intervalo = 3.0;
    
    count = 0;
    
    manager.delegate = self;
    
    //Inicia o mapa
    //[self startMapView];
    
    _latitude = manager.location.coordinate.latitude;
    _longitude = manager.location.coordinate.longitude;

}

-(void) viewDidAppear:(BOOL)animated{
    NSArray *users = [dao fetchWithKey:@"defaultuser" andValue:@"YES"];
    //Testa se existe usuário registrado no BD
    if ([users count] == 0) {
        //Se não existir, carrega view registro
        [self performSegueWithIdentifier:@"SegueViewRegistro" sender:nil];
    }
    else{
        UserInfoMessage *message = [[UserInfoMessage alloc] initWithUser:[dao convertToUserInfo:[users objectAtIndex:0]]];
        [socket sendMessage:[message toJSONString]];
        //Inicia o GPS
        [self startGPS];
    }
    
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Atualiza os markers do mapa através de um timer.
-(void)updateMarker{
    NSLog(@"Testa Timer");
    if(_mapView != nil){
        //NSLog(@"Testando Timer");

        [_mapView clear];
    
        NSMutableArray *usersInfo = [dao convertToUsersInfo:[dao fetchWithKey:@"defaultuser" andValue:@"NO"]];
        for (UserInfo *user in usersInfo) {
            
            [user marker].map = _mapView;
        }
    
        NSMutableArray *usersInfoDefault = [dao convertToUsersInfo:[dao fetchWithKey:@"defaultuser" andValue:@"YES"]];
        for (UserInfo *user in usersInfoDefault) {
            [user marker].map = _mapView;
        }
    }
}

-(void) CustomMaker{
    NSLog(@"Entrou no CustomMaker");
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_latitude
                                                            longitude:_longitude
                                                                 zoom:13];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    // Adicionando um botão ao mapView
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(_mapView.bounds.size.width - 235, _mapView.bounds.size.height - 70, 150, 30);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [button addTarget:self action:@selector(addContato:) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor = [UIColor blackColor];
    button.layer.cornerRadius = 12;
    button.backgroundColor = [UIColor colorWithHue:0.4 saturation:1.000 brightness:0.667 alpha:1.000];
    [button setTitle:@"Adicionar Contato" forState:UIControlStateNormal];
    [_mapView addSubview:button];
    
    //Adicionando o mapView para a nossa view atual
    //[self startGPS];
    self.view = _mapView;
    
    
    //Chamando a função do timer
    timer = [NSTimer scheduledTimerWithTimeInterval:intervalo target:self selector:@selector(updateMarker) userInfo:nil repeats:YES];
    
    
    
}

-(void) HelloMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_latitude
                                                            longitude:_longitude
                                                                 zoom:6];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    marker.snippet = @"Hello World";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = _mapView;

    
    self.view = _mapView;
}

-(void) ChangeTheMapType{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.80948
                                                            longitude:5.965699
                                                                 zoom:2];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    // Available map types: kGMSTypeNormal, kGMSTypeSatellite, kGMSTypeHybrid,
    // kGMSTypeTerrain, kGMSTypeNone
    
    // Set the mapType to Satellite
    _mapView.mapType = kGMSTypeSatellite;
    self.view = _mapView;
    
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
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    GMSMutablePath *path = [GMSMutablePath path];
    [path addLatitude:-33.866 longitude:151.195]; // Sydney
    [path addLatitude:-18.142 longitude:178.431]; // Fiji
    [path addLatitude:21.291 longitude:-157.821]; // Hawaii
    [path addLatitude:37.423 longitude:-122.091]; // Mountain View
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blueColor];
    polyline.strokeWidth = 5.f;
    polyline.map = _mapView;

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
    
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = _mapView;
    
}

-(void) MyLocation{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:12];
    
    
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView.settings.compassButton = YES;
    _mapView.settings.myLocationButton = YES;
    
    // Listen to the myLocation property of GMSMapView.
    [_mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    self.view = _mapView;

    
}

-(void) exampleMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:12];

    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView.myLocationEnabled = YES;
    self.view = _mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = _mapView;
    
    self.view = _mapView;


}

-(void) markerTest{
    
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(51.5, -0.127);
    GMSMarker *london = [GMSMarker markerWithPosition:position];
    london.title = @"London";
    london.snippet = @"Population: 8,174,100";
    london.infoWindowAnchor = CGPointMake(0.5, 0.5);
    london.icon = [UIImage imageNamed:@"house"];
    london.map = _mapView;
    
    self.view = _mapView;
    
    
}

-(void) mandaLocalização{
    
    NSArray *usuarios = [dao fetchWithKey:@"defaultuser" andValue:@"YES"];
    if(usuarios != nil && [usuarios count] > 0){
        
        NSManagedObject *user = [usuarios objectAtIndex:0];
        
        [user setValue:@(_latitude) forKey:@"latitude"];
        [user setValue:@(_longitude) forKey:@"longitude"];
        
        
        [dao update:user];
        
        UserInfoMessage *msg = [[UserInfoMessage alloc] initWithUser:[dao convertToUserInfo:user]];
        
        [socket sendMessage:[msg toJSONString]];
    }
}


- (void)startGPS{
    
    NSLog(@"Entrou no startGPS");
    [_loadingGPS stopAnimating];
    
    manager.distanceFilter = 10.0;
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 10 m


    // update location
    if ([CLLocationManager locationServicesEnabled]){
        [manager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{

//    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location! :(");
    
    [_loadingGPS startAnimating];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    NSArray *users = [dao fetchWithKey:@"defaultuser" andValue:@"YES"];
    
    NSLog(@"Entrou no Delegate");
    if (currentLocation != nil && users.count > 0) {
        

        
        _latitude = currentLocation.coordinate.latitude;
        _longitude = currentLocation.coordinate.longitude;
        
        
        [self mandaLocalização];
    }
    if(count == 0){
        [self CustomMaker];
        count++;
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

- (IBAction)addContato:(UIButton *)sender {
      NSLog(@"Tap no botão 'Adicionar Contato'");
    [self performSegueWithIdentifier:@"SegueAddContato" sender:nil];
}

@end
