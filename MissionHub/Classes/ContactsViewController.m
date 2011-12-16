//
//  ContactsViewController.m
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactsViewController.h"
#import "MissionHubAppDelegate.h"
#import "ContactCell.h"

@implementation ContactsViewController

@synthesize tableView;
@synthesize dataArray;
@synthesize contactCell;

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
    
   	dataArray = [[NSMutableArray alloc] initWithCapacity:50];
    
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/contacts.json?access_token=%@", baseUrl, CurrentUser.accessToken];
    NSLog(@"request:%@", requestUrl);    
    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.response = [[[TTURLJSONResponse alloc] init] autorelease];
    [request send];

    
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    [super requestDidFinishLoad: request];
//    TTURLJSONResponse* response = request.response;
//    NSLog(@"requestDidFinishLoad:%@", response.rootObject);   
//    
//   NSDictionary *result = response.rootObject;
//   NSArray *contacts = [result objectForKey:@"contacts"];
	
//	for (NSDictionary *tempDict in contacts) {
//        NSDictionary *person = [tempDict objectForKey:@"person"];
//        [dataArray addObject: person];
//    }
}

- (void) handleRequestResult:(id *)aResult identifier:(NSString*)aIdentifier {
    
    NSDictionary *result = (NSDictionary *)aResult;
    NSArray *contacts = [result objectForKey:@"contacts"];
    
    for (NSDictionary *tempDict in contacts) {
        NSDictionary *person = [tempDict objectForKey:@"person"];
        [dataArray addObject: person];
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
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://main"]];    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ContactCell";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil];
        cell = contactCell;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.contactCell = nil;
    }
    
    NSDictionary *person = [dataArray objectAtIndex: indexPath.row];
    // Configure the cell.
    [(ContactCell*)cell setData: person];

    return cell;
}

// Detect when player selects a section/row
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *person = [dataArray objectAtIndex: indexPath.row];
    
    TTURLAction *action =  [[[TTURLAction actionWithURLPath:@"mh://contact"] 
                             applyQuery:[NSDictionary dictionaryWithObject:person forKey:@"personData"]] 
                            applyAnimated:YES];
    [[TTNavigator navigator] openURLAction:action];
    
//    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"mh://contact"]
//                                            applyQuery:[NSDictionary dictionaryWithObject:person forKey:@"personData"]]
//                             applyAnimated: YES];
    
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60.0f;
}

- (IBAction)onSegmentChange:(id)sender {
    [dataArray removeAllObjects];
    
    UISegmentedControl *segmentedControl = sender;
    if (segmentedControl.selectedSegmentIndex == 1) {
        [self makeHttpRequest:@"contacts.json" params: @"assigned_to_id=none" identifier:@"contacts"];
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        [self makeHttpRequest:@"contacts.json" params: @"filters[status]=completed" identifier:@"contacts"];
    } else {
        [self makeHttpRequest:@"contacts.json" params: [NSString stringWithFormat:@"assigned_to_id=none", CurrentUser.userId] identifier:@"contacts"];
    }
    
}

@end
