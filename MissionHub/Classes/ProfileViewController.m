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
@synthesize pickerView;
@synthesize orgsArray;

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
    
    orgsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *organization in CurrentUser.organizations) {
        [orgsArray addObject: [organization objectForKey:@"name"]]; 
    }
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

//PickerViewController.m
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

//PickerViewController.m
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [orgsArray count];
}

//PickerViewController.m
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSLog(@"Selected Color: %@. Index of selected color: %i", [orgsArray objectAtIndex:row], row);
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [orgsArray objectAtIndex:row];
}

- (IBAction)onChangeOrgBtn:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if ([btn.currentTitle isEqualToString:@"Change Current Organization"]) {
        [pickerView setHidden: NO];        
        [btn setTitle:@"Click to Close" forState:UIControlStateNormal];
    } else {
        [pickerView setHidden: YES];        
        [btn setTitle:@"Change Current Organization" forState:UIControlStateNormal];
    }
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
