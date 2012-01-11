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

    orgsArray = [[NSMutableArray alloc] init];
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Set user's image
    NSString *picture = [CurrentUser.data objectForKey:@"picture"];
    
    if ([picture length] != 0) {
        TTImageView* profileImageView = [[[TTImageView alloc] initWithFrame:placeHolderImageView.frame] autorelease];
        profileImageView.urlPath = [NSString stringWithFormat:@"%@?type=large", picture];
        [self.view addSubview:profileImageView];        
        
        [placeHolderImageView setHidden: YES];
    }
    
    // set name & org
    [nameLabel setText: CurrentUser.name];
    //[orgLabel setText: [[CurrentUser.organizations objectAtIndex:0] objectForKey:@"name"]];
    [orgsArray removeAllObjects];    
    NSInteger selectedRow = 0;
    NSInteger index = 0;    
    for (NSDictionary *organization in CurrentUser.organizations) {
        NSString *orgId = [NSString stringWithFormat:@"%@", [organization objectForKey:@"org_id"]];
        if ([orgId isEqualToString:CurrentUser.orgId]) {
            selectedRow = index;
            [orgLabel setText: [organization objectForKey:@"name"]];
        }
        [orgsArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: orgId, @"org_id", [organization objectForKey:@"name"], @"name", nil]];         
        index++;
    }

    [pickerView reloadAllComponents];
    [pickerView selectRow:selectedRow inComponent:0 animated:NO];
    
    [self resizeFontForLabel: nameLabel maxSize:20 minSize:10];
    [self resizeFontForLabel: orgLabel maxSize:14 minSize:10];    

    // adjust position
    CGRect nameLabelFrame = nameLabel.frame;
    CGRect orgLabelFrame = orgLabel.frame;
    orgLabelFrame.origin.y = nameLabelFrame.origin.y + nameLabelFrame.size.height + 5;
    [orgLabel setFrame:orgLabelFrame];
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
    
    NSDictionary *dict = [orgsArray objectAtIndex:row];
    
    NSLog(@"Selected org: %@ id: %@", [dict objectForKey:@"name"], [dict objectForKey:@"org_id"]);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[dict objectForKey:@"org_id"] forKey:@"orgId"];			
    
    CurrentUser.orgId = [dict objectForKey:@"org_id"];
    [orgLabel setText:[dict objectForKey:@"name"]];

    [self viewDidAppear:NO];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *dict = [orgsArray objectAtIndex:row];
    return [dict objectForKey:@"name"];
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
