//
//  MainViewController.m
//  MissionHub
//
//  Created by David Ang on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    NSLog(@"viewWillAppear");
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator.topViewController.navigationController setNavigationBarHidden:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) removeAlert {
   TTLabel *alert = [[self.view subviews] lastObject];

    [UIView animateWithDuration:1.25f
                     animations:^{alert.alpha = 0.0;
                     }
                     completion:^(BOOL done){
                         [alert removeFromSuperview];
                                            }];

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
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"mh://profile"] applyAnimated:YES]];
}

- (IBAction)onLogoutBtn:(id)sender {
    [CurrentUser logout];
}

- (IBAction)onContactsBtn:(id)sender {
    //[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"mh://contacts" ] applyAnimated:YES]];
   [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"mh://nib/ContactsViewController" ] applyAnimated:YES]];
}

- (IBAction)onSurveyBtn:(id)sender {

    NSString *baseUrl = [[AppDelegate config] objectForKey:@"base_url"];
    NSString *surveysUrl = [NSString stringWithFormat:@"%@/surveys?access_token=%@&org_id=%@", baseUrl, CurrentUser.accessToken, CurrentUser.orgId];

    NSLog(@"%@", surveysUrl);
    TTOpenURL(surveysUrl);

    TTNavigator *navigator = [TTNavigator navigator];
    [navigator.topViewController.navigationController setNavigationBarHidden:NO];
}


@end
