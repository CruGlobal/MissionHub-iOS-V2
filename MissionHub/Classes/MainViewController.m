//
//  MainViewController.m
//  MissionHub
//
//  Created by David Ang on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "MissionHubAppDelegate.h"
#import "NiceAlertView.h"

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
//    TTLabel *alert = [[TTLabel alloc] initWithText:@"I'm a ttlabel"];
//    alert.frame = CGRectMake(40, self.view.bounds.size.height / 2, 250, 100);
//    alert.style =  [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:5] next:
//                    [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.5) blur:5 offset:CGSizeMake(1, 1) next:
//                      [TTSolidFillStyle styleWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.9] next:
//                        [TTTextStyle styleWithFont:[UIFont systemFontOfSize:25] color:[[UIColor whiteColor] colorWithAlphaComponent:1.0] next: nil                        
//                            ]]]];
//    [alert setBackgroundColor:[UIColor clearColor]];
////    [alert sizeToFit];
//    
//    [[[UIApplication sharedApplication] keyWindow] addSubview:alert];
//    TT_RELEASE_SAFELY(alert);
//   
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self
//                                                       selector:@selector(removeAlert) userInfo:nil repeats:NO];
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
    NSString *orgId = @"604";
    
    NSString *surveysUrl = [NSString stringWithFormat:@"%@/surveys?access_token=%@&org_id", baseUrl, CurrentUser.accessToken, orgId];
    
    NSLog(@"%@", surveysUrl);
    TTOpenURL(surveysUrl); 
    
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator.topViewController.navigationController setNavigationBarHidden:NO];   
    
}


@end
