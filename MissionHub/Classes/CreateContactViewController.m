//
//  CreateContactViewController.m
//  MissionHub
//
//  Created by David Ang on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateContactViewController.h"
#import "Contact.h"

@interface CreateContactViewController ()
- (void)onCreateContactBtn:(QButtonElement *)buttonElement;
- (void)onCreateContact;

@end

@implementation CreateContactViewController

- (void)setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView {
	
    [super setQuickDialogTableView:aQuickDialogTableView];
	
    self.quickDialogTableView.backgroundView = nil;
//    self.quickDialogTableView.backgroundColor = [UIColor colorWithHue:0.1174 saturation:0.7131 brightness:0.8618 alpha:1.0000];
    self.quickDialogTableView.bounces = YES;
    self.quickDialogTableView.styleProvider = self;
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
//    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(onCreateContact)];
	
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelBtn:)];
	
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = nil;
}

- (void)onCreateContactBtn:(QButtonElement *)buttonElement {
	[self onCreateContact];
}

- (IBAction)onCancelBtn:(id)sender {
	
    [self dismissModalViewControllerAnimated:YES];
}

- (void)onCreateContact {
	
	Contact *contact = [[Contact alloc] init];
    [self.root fetchValueIntoObject:contact];
    
    if (contact.firstName == nil || [contact.firstName length] == 0) {
        [[NiceAlertView alloc] initWithText: @"A First Name is required to create a contact."];
        return;
    }
    
    [self loading:YES];    
    
    [contact create:^(int result){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"contactCreated" object: nil ];    
        
        [self loading:NO];
        [self dismissModalViewControllerAnimated:YES];
        
    }];
	
}

-(void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath{
//    cell.backgroundColor = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
//	
//    if ([element isKindOfClass:[QEntryElement class]] || [element isKindOfClass:[QButtonElement class]]|| [element isKindOfClass:[QBooleanElement class]]){
//        cell.textLabel.textColor = [UIColor colorWithRed:0.6033 green:0.2323 blue:0.0000 alpha:1.0000];
//    }   
}

- (BOOL)QEntryShouldChangeCharactersInRangeForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Should change characters");
    return YES;
}

- (void)QEntryEditingChangedForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Editing changed");
}


- (void)QEntryMustReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Must return");
	
}

@end
