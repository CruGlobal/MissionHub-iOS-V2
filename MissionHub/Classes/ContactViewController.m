//
//  ContactViewController.m
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactViewController.h"
#import "MissionHubAppDelegate.h"

@implementation ContactViewController

@synthesize personData;
@synthesize nameLbl;

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query { 
    if (self = [super init]){ 
        self.personData =[query objectForKey:@"personData"]; 
    } 
    return self; 
} 


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [nameLbl setText:[self.personData objectForKey:@"name"]];
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

- (IBAction)onBackBtn:(id)sender {    
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://contacts"]];    
}

#pragma mark - button events

- (IBAction)onCallBtn:(id)sender {
    
}

- (IBAction)onSmsBtn:(id)sender {
    
}

- (IBAction)onEmailBtn:(id)sender {
    
}

- (IBAction)onAssignBtn:(id)sender {
    
}

- (IBAction)onRejoicableBtn:(id)sender {
    
}

- (IBAction)onStatusBtn:(id)sender {
    
}

- (IBAction)onSaveBtn:(id)sender {
    
}


@end
