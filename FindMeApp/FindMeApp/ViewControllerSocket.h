//
//  ViewControllerSocket.h
//  FindMeApp
//
//  Created by bepid on 27/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SRWebSocket.h>

@interface ViewControllerSocket : UIViewController <SRWebSocketDelegate>

- (IBAction)sendMessage:(UIButton *)sender;

@end
