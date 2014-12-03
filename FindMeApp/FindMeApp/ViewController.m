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
    
    NSTimer *timer;
    NSTimeInterval intervalo;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Limpando todos os usuários, menos o default do bd
    UserInfoDAO *dao = [[UserInfoDAO alloc] init];
    [dao clearAllExceptDefault];
    
    socket = [WebSocketSingleton getConnection];
    manager = [[CLLocationManager alloc] init];
    _UsuariosAtivos = [NSMutableArray new];
    
    _latitude = 0.0;
    _longitude = 0.0;
    
    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    intervalo = 60.0;
    
    //Inicia o mapa
    [self startMapView];

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
        UserInfoMessage *message = [[UserInfoMessage alloc] initWithUser:[dao convertToUserInfo:[users objectAtIndex:0]]];
        [socket sendMessage:[message toJSONString]];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Atualiza os markers do mapa através de um timer.
-(void)updateMarker{
    NSLog(@"Testando Timer");
    UserInfoDAO *userDAO = [UserInfoDAO new];
    
//    NSMutableArray *usersInfo = [userDAO convertToUsersInfo:[userDAO fetchWithKey:@"defaultuser" andValue:@"NO"]];
    
    // Limpa todos os markers
    [_mapView clear];
    
    NSMutableArray *usersInfo = [userDAO convertToUsersInfo:[userDAO fetchWithKey:@"defaultuser" andValue:@"NO"]];
    for (UserInfo *user in usersInfo) {
        [user marker].map = _mapView;
    }
    
    NSMutableArray *usersInfoDefault = [userDAO convertToUsersInfo:[userDAO fetchWithKey:@"defaultuser" andValue:@"YES"]];
    for (UserInfo *user in usersInfoDefault) {
        [user marker].map = _mapView;
    }

}

-(void) CustomMaker{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_latitude
                                                            longitude:_longitude
                                                                 zoom:13];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    // Definindo um Marker ao mapView
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(_latitude, _longitude);
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = [UIImage imageNamed:@"flag_icon"];
    marker.map = _mapView;
    
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

-(void) mandaLocalização{
    UserInfoDAO *userInfoDAO = [[UserInfoDAO alloc]init];

    
    NSManagedObject *user = [[userInfoDAO fetchWithKey:@"defaultuser" andValue:@"YES"] objectAtIndex:0];
    
    [user setValue:@(_latitude) forKey:@"latitude"];
    [user setValue:@(_longitude) forKey:@"longitude"];

    
    [userInfoDAO update:user];
    
    UserInfoMessage *msg = [[UserInfoMessage alloc] initWithUser:[userInfoDAO convertToUserInfo:user]];
 
    [socket sendMessage:[msg toJSONString]];
    
    
    //{userInfo"{"email":"bla@bla.com","telefone":"35699856","latitude":37.33241,"longitude":-122.0305,"user":"Yuri BlaBla"}}
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

- (void)startMapView{
    
    manager.delegate = self;
   // manager.desiredAccuracy = kCLLocationAccuracyBest;
    //manager.distanceFilter = 10.0;
    //manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //[manager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //[manager setDistanceFilter:kCLDistanceFilterNone];
    //manager.distanceFilter = 50.0f;
    //manager.headingFilter = 5;
    //[manager startUpdatingLocation];
    
    [_loadingGPS stopAnimating];
    
    manager.distanceFilter = 10.0;
    manager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m


    // update location
    if ([CLLocationManager locationServicesEnabled]){
        [manager startUpdatingLocation];
        
    }
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{

//    NSLog(@"Error: %@", error);
//    NSLog(@"Failed to get location! :(");
    
    [_loadingGPS startAnimating];
    UIAlertView *alerta;
    alerta = [[UIAlertView alloc] initWithTitle:@"Por gentileza" message:@"Ative o seu GPS" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alerta show];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Distance Location: %f", [newLocation distanceFromLocation:oldLocation]);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        _latitude = currentLocation.coordinate.latitude;
        _longitude = currentLocation.coordinate.longitude;
        
        [self CustomMaker];
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


- (IBAction)addContato:(UIButton *)sender {
      NSLog(@"Tap no botão 'Adicionar Contato'");
    [self performSegueWithIdentifier:@"SegueAddContato" sender:nil];
}

@end
