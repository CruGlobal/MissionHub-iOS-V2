//
//  LoginViewController.m
//  MissionHub
//
//  Created by David Ang on 12/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
@synthesize aboutBtn;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"initWithNibName");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"viewDidLoad");

}

- (void)viewWillAppear:(BOOL)animated 
{
    NSLog(@"viewWillAppear");
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator.topViewController.navigationController setNavigationBarHidden:YES];  

}

- (void)viewDidUnload
{
    [self setAboutBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onAboutBtn:(id)sender {    
    TTOpenURL(@"http://www.missionhub.com?mobile=0"); 
    
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator.topViewController.navigationController setNavigationBarHidden:NO];   
}

- (IBAction)onLoginBtn:(id)sender {
     NSLog(@"onLoginBtn");
}


- (void)dealloc {
    [aboutBtn release];
    [super dealloc];
}
@end
