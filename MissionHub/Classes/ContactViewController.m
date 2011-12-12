//
//  ContactViewController.m
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactViewController.h"
#import "MissionHubAppDelegate.h"
#import "CommentCell.h"
#import "SimpleCell.h"

@implementation ContactRequestDelegate

- (id) initWithArray:(NSMutableArray*)data tableView:(UITableView*)aTableView {
      if (self = [super init]) {
          
    tempData = data;
    tempTableView = aTableView;
      }
    return self;
}

- (void) requestDidFinishLoad:(TTURLRequest*)request {
    TTURLJSONResponse* response = request.response;
    NSLog(@"requestDidStartLoad:%@", response.rootObject);   
    NSLog(@"delegate subclass");
    
    NSDictionary *tempDict = response.rootObject;
    NSArray *people = [tempDict objectForKey:@"people"];
    NSDictionary *personAndFormDict = [people objectAtIndex:0];
    NSDictionary *person = [personAndFormDict objectForKey:@"person"];

    [tempData addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"First Contact Date", @"label", [person objectForKey:@"first_contact_date"], @"value", nil]];
            
    [tempTableView reloadData];
}

@end

@implementation ContactViewController

@synthesize personData;
@synthesize nameLbl;
@synthesize tableView;
@synthesize commentsArray;
@synthesize infoArray;
@synthesize surveyArray;
@synthesize simpleCell;
@synthesize commentCell;
@synthesize segmentedControl;


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
    infoArray = [[NSMutableArray alloc] initWithCapacity:10];

//    [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Assigned to", CurrentUser.
//    dict = 
//            @"/opt/picture.png", @"Luca", 
//            @"/home/nico/birthday.png", @"Birthday Photo", 
//            @"/home/nico/birthday.png", @"Birthday Image", 
//            @"/home/marghe/pic.jpg", @"My Sister", nil];
    
    
    // Do any additional setup after loading the view from its nib.
    [nameLbl setText:[self.personData objectForKey:@"name"]];
    
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/followup_comments/%@.json?access_token=%@", baseUrl, [self.personData objectForKey:@"id"], CurrentUser.accessToken];
    NSLog(@"request:%@", requestUrl);    
    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.response = [[[TTURLJSONResponse alloc] init] autorelease];
    [request send];
     
     
     
     requestUrl = [NSString stringWithFormat:@"%@/contacts/%@.json?access_token=%@", baseUrl, [self.personData objectForKey:@"id"], CurrentUser.accessToken];
     NSLog(@"request:%@", requestUrl);    
     request = [TTURLRequest requestWithURL: requestUrl delegate: [[ContactRequestDelegate alloc] initWithArray:infoArray tableView:self.tableView]];
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
    if (segmentedControl.selectedSegmentIndex == 1) {
        return [infoArray count];        
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        return [surveyArray count];                
    }
    
    return [commentsArray count];    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CommentCell";
    static NSString *CellIdentifier2 = @"SimpleCell";    
    
    UITableViewCell *cell = nil;
    
    // Dequeue or create a cell of the appropriate type.
    if (segmentedControl.selectedSegmentIndex == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
            cell = commentCell;
            self.commentCell = nil;
        }
        
        NSDictionary *tempDict = [commentsArray objectAtIndex: indexPath.row];
        NSDictionary *comment = [tempDict objectForKey:@"comment"];
        
        [(CommentCell*)cell setData: comment];
    }
        
    if (segmentedControl.selectedSegmentIndex == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"SimpleCell" owner:self options:nil];
            cell = simpleCell;
            self.simpleCell = nil;
        }

        NSDictionary *tempDict = [infoArray objectAtIndex: indexPath.row];        
        [(SimpleCell*)cell setData: tempDict];
    }
    // Configure the cell.
    //cell.textLabel.text = [NSString stringWithFormat:@"%@", [comment objectForKey:@"comment"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60.0f;
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

- (IBAction)onSegmentChange:(id)sender {    
        
    [tableView reloadData];
}


@end
