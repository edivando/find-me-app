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
    WebSocket *socket;
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
    self.nome.delegate = self;
    self.telefone.delegate = self;
    self.email.delegate = self;
    
    socket = [WebSocketSingleton getConnection];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)sendMessage:(UIButton *)sender {
    // Salva no Banco de Dados Local
    UserInfoDAO *dao = [[UserInfoDAO alloc] init];
    UserInfo *novo = [[UserInfo alloc] initWithUser:self.nome.text latitude:0.0 longitude:0.0 email:self.email.text telefone:self.telefone.text];
    [dao save:novo];
    _nome.text = @"";
    _telefone.text = @"";
    _email.text = @"";    
    
    UserInfo *position = [[UserInfo alloc]initWithUser:@"Yuri BlaBla" latitude:23.876 longitude:87.9765 email:@"bla@bla.com" telefone:@"35699856"];
    
    NSLog(@"JSON STRING:\n%@",[position toJSONString]);
    
    [socket sendMessage:[position toJSONString]];
}

- (IBAction)loadData:(UIButton *)sender {
//    AppDelegate *appDelegate =((AppDelegate*)[[UIApplication sharedApplication] delegate]);
//    
//    NSManagedObjectContext *context =[appDelegate managedObjectContext];
//    
//    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Usuario" inManagedObjectContext:context];
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entityDesc];
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(nome = %@)", _nome.text];
//    [request setPredicate:pred];
    NSManagedObject *matches = nil;
//    
//    NSError *error;
//    NSArray *objects = [context executeFetchRequest:request error:&error];
    UserInfoDAO *dao = [[UserInfoDAO alloc] init];
    NSArray *objects = [dao fetchWithKey:@"nome" andValue: _nome.text];
    if ([objects count] == 0) {
        _telefone.text = @"No matches";
    } else {
        matches = objects[0];
        _telefone.text = [matches valueForKey:@"telefone"];
        _email.text = [matches valueForKey:@"email"];
    }
    
}
@end
