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
    GMSMapView *mapView_;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //mapView_.mapType = kGMSTypeSatellite;
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;
    
    NSLog(@"User's location: %@", mapView_.myLocation);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
