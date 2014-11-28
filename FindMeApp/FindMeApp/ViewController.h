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


@interface ViewController : UIViewController<CLLocationManagerDelegate>

- (IBAction)getLocation:(UIButton *)sender;
@property(nonatomic) float latitude;
@property(nonatomic) float longitude;

-(void) mandaLocalização;

@end
