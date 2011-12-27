//
//  ProfileViewController.m
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import <Three20/Three20.h>
#import "User.h"
#import "HJManagedImageV.h"
#import "MissionHubAppDelegate.h"

@implementation ProfileViewController

@synthesize nameLabel;
@synthesize orgLabel;
@synthesize placeHolderImageView;

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

    // Set user's image
    NSString *picture = [CurrentUser.data objectForKey:@"picture"];
    
    if ([picture length] != 0) {
        NSString *fbUrl = [NSString stringWithFormat:@"%@?type=large", picture]; 
        NSURL * imageURL = [NSURL URLWithString: fbUrl];

        HJManagedImageV* mi = [[[HJManagedImageV alloc] initWithFrame:placeHolderImageView.frame] autorelease];;
        [self.view addSubview: mi];
        mi.url = imageURL;
        
        [AppDelegate.imageManager manage:mi];
        
        [placeHolderImageView setHidden: YES];
    }
    
    // set name & org
    [nameLabel setText: CurrentUser.name];
    [orgLabel setText: [[CurrentUser.organizations objectAtIndex:0] objectForKey:@"name"]];

    //profileImageView.image = image;
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

- (IBAction)onLogoutBtn:(id)sender {    
    [CurrentUser logout];
}


- (IBAction)onBackBtn:(id)sender {    
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://main"]];    
}

- (void)dealloc {
    [super dealloc];
}


@end
