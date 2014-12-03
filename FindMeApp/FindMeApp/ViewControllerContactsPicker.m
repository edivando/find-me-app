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
    dao = [[UserInfoDAO alloc] init];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource: self];
    //contatos = [dao fetchWithKey:@"defaultuser" andValue:@"NO"];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //edit table
    [dao deleteManaged:[contatos objectAtIndex:indexPath.row]];
    [self.tableView reloadData];
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
    cell.lbTitle.text = [[contatos objectAtIndex:[indexPath row]] valueForKey:@"nome"];
    cell.lbDetail.text = [[contatos objectAtIndex:[indexPath row]] valueForKey:@"telefone"];
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
        UserInfo *newUser = [[UserInfo alloc] initWithUser:name latitude:0.0 longitude:0.0 email:@"" telefone:phone idServer:0 connectionId:@""];
        [dao save:newUser];
        
        //Instanciar objeto e salvar no banco
        
        //self.lbTel.text = phone;
        //self.lbNome.text = name;
    }
    CFRelease(phoneNumbers);
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

- (IBAction)addContato:(UIButton *)sender {
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
@end
