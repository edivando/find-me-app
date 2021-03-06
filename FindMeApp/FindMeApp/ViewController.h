//
//  ViewController.h
//  FindMeApp
//
//  Created by bepid on 26/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewControllerSocket.h"
#import "ViewControllerRegistration.h"
#import "UserInfoMessage.h"
#import "WebSocket.h"
#import "WebSocketSingleton.h"
#import "UserInfo.h"
#import "ViewControllerContactsPicker.h"
#import "StyleButton.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate, GMSMapViewDelegate>

@property(nonatomic) float latitude;
@property(nonatomic) float longitude;
@property(nonatomic) NSMutableArray* UsuariosAtivos;
@property(nonatomic) GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingGPS;

-(void) mandaLocalização;

@end
