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
@synthesize tableView;
@synthesize commentsArray;
@synthesize infoArray;
@synthesize surveyArray;

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
    
    commentsArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    // Do any additional setup after loading the view from its nib.
    [nameLbl setText:[self.personData objectForKey:@"name"]];
    
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/followup_comments/%@.json?access_token=%@", baseUrl, [self.personData objectForKey:@"id"], CurrentUser.accessToken];
    NSLog(@"request:%@", requestUrl);    
    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.response = [[[TTURLJSONResponse alloc] init] autorelease];
    [request send];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLJSONResponse* response = request.response;
    NSLog(@"requestDidStartLoad:%@", response.rootObject);   
    
    NSArray *tempArray = response.rootObject;
    
	for (NSDictionary *tempDict in tempArray) {
        NSDictionary *comment = [tempDict objectForKey:@"followup_comment"];
        [commentsArray addObject: comment];
    }
    [tableView reloadData];
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

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [commentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];      
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *tempDict = [commentsArray objectAtIndex: indexPath.row];
    NSDictionary *comment = [tempDict objectForKey:@"comment"];
    // Configure the cell.
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [comment objectForKey:@"comment"]];
    return cell;
}

// Detect when player selects a section/row
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
