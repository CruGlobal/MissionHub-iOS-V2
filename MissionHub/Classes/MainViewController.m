//
//  MainViewController.m
//  MissionHub
//
//  Created by David Ang on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "MissionHubAppDelegate.h"
#import <Three20/Three20.h>

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)viewWillAppear:(BOOL)animated 
{
    NSLog(@"viewWillAppear");
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator.topViewController.navigationController setNavigationBarHidden:YES];  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onProfileBtn:(id)sender {
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://profile"]];
}

- (IBAction)onLogoutBtn:(id)sender {
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"base_url"];
    
    NSString *logoutUrl = [NSString stringWithFormat:@"%@/auth/facebook/logout", baseUrl];
    
    NSLog(@"%@", logoutUrl);
    TTOpenURL(logoutUrl); 
    
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator.topViewController.navigationController setNavigationBarHidden:NO];   
}

- (IBAction)onContactsBtn:(id)sender {
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://contacts"]];    
}

- (IBAction)onSurveyBtn:(id)sender {

    NSString *baseUrl = [[AppDelegate config] objectForKey:@"base_url"];
    NSString *orgId = @"604";
    NSString *accessToken = @"658ff25127cecc27fee7430437ac7b48e2a0ddc7076f32b0422ce76137bba980";
    
    NSString *surveysUrl = [NSString stringWithFormat:@"%@/surveys?access_token=%@&org_id", baseUrl, accessToken, orgId];
    
    NSLog(@"%@", surveysUrl);
    TTOpenURL(surveysUrl); 
    
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator.topViewController.navigationController setNavigationBarHidden:NO];   
    
}


@end
