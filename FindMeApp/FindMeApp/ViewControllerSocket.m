//
//  ViewControllerSocket.m
//  FindMeApp
//
//  Created by bepid on 27/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "ViewControllerSocket.h"

@interface ViewControllerSocket ()

@end

@implementation ViewControllerSocket{
    SRWebSocket *webSocket;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self connectWebSocket];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Connection

- (void)connectWebSocket {
    webSocket.delegate = nil;
    webSocket = nil;
    
    NSString *urlString = @"wss://findme-edivando.rhcloud.com:8443/server?userName=Yuri";
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    newWebSocket.delegate = self;
    
    [newWebSocket open];
}


#pragma mark - SRWebSocket delegate

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    webSocket = newWebSocket;
    [webSocket send:[NSString stringWithFormat:@"Hello from %@", [UIDevice currentDevice].name]];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [self connectWebSocket];
    NSLog(@"Error: %@",error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Reason: %@",reason);
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Msg recebida: %@", message);
    //self.messagesTextView.text = [NSString stringWithFormat:@"%@\n%@", self.messagesTextView.text, message];
}

- (IBAction)sendMessage:(UIButton *)sender {
    [webSocket send:@"assdsdsd"];
    //    self.messageTextField.text = nil;
}
@end
