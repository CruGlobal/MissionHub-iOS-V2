//
//  CreateContactViewController.m
//  MissionHub
//
//  Created by David Ang on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateContactViewController.h"
#import "Contact.h"

@implementation CreateContactViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc {
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"CreateContactViewController viewDidLoad");
}

- (void) viewWillAppear:(BOOL)animated {
    
    QRootElement *root =     [[QRootElement alloc] initWithJSONFile:@"createContact"];
    UINavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtn:)];          
    navigation.navigationBar.topItem.leftBarButtonItem = anotherButton;
    
    [self presentModalViewController:navigation animated:YES];
}

- (IBAction)onBackBtn:(id)sender {    
    TTNavigator *navigator = [TTNavigator navigator];
    //[navigator.topViewController.navigationController setNavigationBarHidden:YES];       
    [navigator openURLAction:[TTURLAction actionWithURLPath:@"mh://contacts"]];    
    //[self.navigationController popToViewController:navigator.topViewController animated:YES];        

    [self dismissModalViewControllerAnimated:YES];
}

@end


@implementation CreateContactQuickDialogDelegate 

- (void)onCreateContactBtn:(QButtonElement *)buttonElement {
    [self loading:YES];
    Contact *contact = [[Contact alloc] init];
    [self.root fetchValueIntoObject:contact];
    
    [contact create:^(int result){
        // Prints 10
        NSLog(@"using blocks");
        [self loading:NO];
        [self dismissModalViewControllerAnimated:YES];  
    }];
    
}
@end