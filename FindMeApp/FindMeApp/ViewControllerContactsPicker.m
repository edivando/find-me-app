//
//  ViewControllerContactsPicker.m
//  FindMeApp
//
//  Created by bepid on 01/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "ViewControllerContactsPicker.h"

@interface ViewControllerContactsPicker ()

@end

@implementation ViewControllerContactsPicker{
    UserInfoDAO *dao;
    UIAlertView *alert;
    NSMutableArray *contatos;
    NSTimer *timerToUpdateTable;
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
    self.tableView.contentInset = UIEdgeInsetsZero;
    srandom(time(nil));
    dao = [[UserInfoDAO alloc] init];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource: self];
    socket = [WebSocketSingleton getConnection];
    socket.pickerContacts = self;
//    timerToUpdateTable = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateTable) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self updateTable];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [dao deleteManaged:[contatos objectAtIndex:indexPath.row]];
    [self updateTable];
}

-(void) updateTable{
    [self.tableView reloadData];
    if (contatos.count == 0) {
        [self contactsSubview];
    }
    else{
        [self.view addSubview:self.tableView];
    }
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    contatos = [[NSMutableArray alloc] initWithArray:[dao fetchWithKey:@"defaultuser" andValue:@"NO"]];
    return [contatos count];
}

-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Remover";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    UserInfo *user = [dao convertToUserInfo:[contatos objectAtIndex:[indexPath row]]];

    cell.lbTitle.text = user.user;
    cell.userCell = user;
    cell.lbTelefone.text = user.telefone;
    cell.imgUserColor.backgroundColor = [user color];
    
    if ([user.permission isEqualToString:@"YES"]) {
        [cell.permission setBackgroundImage:[UIImage imageNamed:@"unlocked"] forState:UIControlStateNormal];
        [cell.permission setBackgroundImage:[UIImage imageNamed:@"unlocked"] forState:UIControlStateHighlighted];
        cell.permission.hidden = NO;
        cell.loadPermission.hidden = YES;
    }
    else{
        [cell.permission setBackgroundImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
        [cell.permission setBackgroundImage:[UIImage imageNamed:@"lock"] forState:UIControlStateHighlighted];

    }
    if ([user.status isEqualToString:@"CONNECTED"]){
        cell.imgStatus.image = [UIImage imageNamed:@"online"];
    }
    else {
        cell.imgStatus.image = [UIImage imageNamed:@"offline"];
    }
    cell.pickerDelegate = self;
    return cell;
}

-(void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

- (void)displayPerson:(ABRecordRef)person{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty);
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,kABPersonPhoneProperty);
    if(name == nil){
        alert = [[UIAlertView alloc] initWithTitle:@"Contato inválido" message:@"O contato escolhido não possui um nome" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if (ABMultiValueGetCount(phoneNumbers) == 0){
        alert = [[UIAlertView alloc] initWithTitle:@"Contato inválido" message:@"O contato escolhido não possui um telefone" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else {
        phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
        UserInfo *newUser = [[UserInfo alloc] initWithUser:name latitude:0.0 longitude:0.0 email:@"" telefone:phone deviceId:@"" connectionId:@""];
        newUser.telefone = [newUser telefoneFormat];
        newUser.cor = [self randCor];
        NSArray *users = [dao fetchWithKey:@"telefone" andValue:phone];
        if (users.count == 0) {
            [dao save:newUser];
            NSArray *usuarios = [dao fetchWithKey:@"defaultuser" andValue:@"YES"];
            [socket sendPermissionMessageFrom:[dao convertToUserInfo:[usuarios objectAtIndex:0]] To:newUser status:@"CONNECT"];
        }
    }
    CFRelease(phoneNumbers);
}

-(void)contactsSubview{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *subView = [[UIView alloc] initWithFrame:applicationFrame];
    
    //Imagem
    UIImage *imagem = [UIImage imageNamed:@"contactsEmpty"];
    CGRect imgFrame = CGRectMake(0,0, 120, 120);
    UIImageView *imagemView = [[UIImageView alloc] initWithFrame:imgFrame];
    [imagemView setImage:imagem];
    [imagemView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/3)];
    
    //Label 1
    UILabel *labelSubContact = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    [labelSubContact setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
    labelSubContact.text = @"Você não tem contatos.";
    labelSubContact.numberOfLines = 1;
    labelSubContact.font = [UIFont boldSystemFontOfSize:15];
    labelSubContact.adjustsFontSizeToFitWidth = YES;
    labelSubContact.textColor = [UIColor grayColor];
    labelSubContact.textAlignment = NSTextAlignmentCenter;
    
    //Label 2
    UILabel *labelSubContact2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    [labelSubContact2 setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/1.7)];
    labelSubContact2.text = @"Adicione novos contatos para vê-los no mapa.";
    labelSubContact2.numberOfLines = 1;
    labelSubContact2.font = [UIFont systemFontOfSize:12];
    labelSubContact2.adjustsFontSizeToFitWidth = YES;
    labelSubContact2.textColor = [UIColor grayColor];
    labelSubContact2.textAlignment = NSTextAlignmentCenter;

    [subView addSubview:imagemView];
    [subView addSubview:labelSubContact];
    [subView addSubview:labelSubContact2];
    [subView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:subView];
}



-(NSString*) randCor{
    return [NSString stringWithFormat:@"%ld|%ld|%ld", random()%255,random()%50,random()%255];
}

- (IBAction)addContato:(UIButton *)sender {
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
@end
