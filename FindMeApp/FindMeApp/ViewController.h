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

@interface ViewController : UIViewController<CLLocationManagerDelegate>

- (IBAction)getLocation:(UIButton *)sender;
@property(nonatomic) float latitude;
@property(nonatomic) float longitude;
@property(nonatomic) NSMutableArray* UsuariosAtivos;
@property(nonatomic) GMSMapView *mapView;
- (IBAction)addContato:(UIButton *)sender;

-(void) mandaLocalização;

@end
