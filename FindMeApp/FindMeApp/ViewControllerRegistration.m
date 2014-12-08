//
//  ViewControllerRegistration.m
//  FindMeApp
//
//  Created by Yuri Anfrisio Reis on 11/29/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "ViewControllerRegistration.h"

@interface ViewControllerRegistration ()

@end

@implementation ViewControllerRegistration{
    UIAlertView *alert;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"FindMe"];
    self.textTelefone.delegate = self;
    self.textTelefone.placeholder = @"(__) ____-____";
    self.textNome.delegate = self;
    self.textEmail.delegate = self;
    self.tableView.backgroundColor = [[UIColor alloc] initWithRed:255.0f/255.0f green:256.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    
    //Setando barra do teclado numerico
    
//    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
//    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
//    numberToolbar.items = [NSArray arrayWithObjects:
//                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
//                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
//                           nil];
//    [numberToolbar sizeToFit];
//    self.textTelefone.inputAccessoryView = numberToolbar;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIResponder* nextResponder;
    if ([textField isEqual:self.textNome]) {
        nextResponder = self.textEmail;
        [nextResponder becomeFirstResponder];
    }
    else if ([textField isEqual:self.textEmail]){
        nextResponder = self.textTelefone;
        [nextResponder becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    return YES;
}

//Metodos para o teclado numerico
//-(void)cancelNumberPad{
//    [self.textTelefone resignFirstResponder];
//    self.textTelefone.text = @"";
//}
//
//-(void)doneWithNumberPad{
//    [self.textTelefone resignFirstResponder];
//}

- (IBAction)btDone:(UIButton *)sender {
    if ([self.textNome.text isEqual: @""]) {
        [self alertTitle:@"Campo obrigatório não preenchido!" message:@"Favor preencher o campo Nome"];
    }
    else if ([self.textTelefone.text isEqual: @""]){
        [self alertTitle:@"Campo obrigatório não preenchido!" message:@"Favor preencher o campo Telefone"];
    }
    else if (self.textTelefone.text.length <8){
        [self alertTitle:@"Telefone invalido" message:@"Favor preencher o campo Telefone com pelo menos 8 digitos"];
    }
    else{
        UserInfo *newUser = [[UserInfo alloc]initWithUser:self.textNome.text latitude:0.0 longitude:0.0 email:self.textEmail.text telefone:self.textTelefone.text deviceId:[[[UIDevice currentDevice] identifierForVendor] UUIDString] connectionId:@"0"];
        newUser.cor = @"108|165|58";
        newUser.telefone = [[newUser.telefone componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]componentsJoinedByString:@""];
        UserInfoDAO *dao = [[UserInfoDAO alloc] init];
        [dao save:newUser];
        [self sendUserInfoMessage:newUser];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void) sendUserInfoMessage:(UserInfo*)user{
    UserInfoMessage *message = [[UserInfoMessage alloc] initWithUser:user];
    WebSocket *socket = [WebSocketSingleton getConnection];
    [socket sendMessage:[message toJSONString]];
}


-(void) alertTitle:(NSString*)title message:(NSString*)message{
    alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
