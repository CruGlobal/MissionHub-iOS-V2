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
#import "MockDataSource.h"
#import "ContactsListDataSource.h"

@implementation ContactsViewController

@synthesize delegate = _delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) createModel {
    self.dataSource = [[[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[assigned_to]=%@", CurrentUser.userId]] autorelease];
}

- (void)loadView {
    [super loadView];
    
    TTTableViewController* searchController = [[[TTTableViewController alloc] init] autorelease];
    self.searchViewController = searchController;
    self.tableView.tableHeaderView = _searchController.searchBar;
    
    ContactsListDataSource *ds = [[[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[assigned_to]=%@", CurrentUser.userId]] autorelease];
    //searchController.dataSource = [[[MockSearchDataSource alloc] initWithDuration:1.5] autorelease];    
    self.searchViewController.dataSource = ds;
    
    [self.tableView setFrame:CGRectMake(0, 33, 320, 398)];    
}

- (id<TTTableViewDelegate>) createDelegate {
    return (id<TTTableViewDelegate>)[[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    
    [_delegate searchContactsController:self didSelectObject:object];

    TTTableSubtitleItem *item = (TTTableSubtitleItem*)object;
    NSDictionary *person = item.userInfo;
    TTURLAction *action =  [[[TTURLAction actionWithURLPath:@"mh://contact"] 
                             applyQuery:[NSDictionary dictionaryWithObject:person forKey:@"personData"]] 
                            applyAnimated:YES];
    [[TTNavigator navigator] openURLAction:action];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//// TTSearchTextFieldDelegate
//
- (void)textField:(TTSearchTextField*)textField didSelectObject:(id)object {
    [_delegate searchContactsController:self didSelectObject:object];
    
    
    [self didSelectObject:object atIndexPath:nil];
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


- (IBAction)onAddContactBtn:(id)sender {
    //[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://nib/CreateContactViewController"]];       
    //[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://createContact"]];       
    
    QRootElement *root =     [[QRootElement alloc] initWithJSONFile:@"createContact"];
    UINavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];

    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onCreateContactBackBtn:)];          
    navigation.navigationBar.topItem.leftBarButtonItem = anotherButton;

    [self presentModalViewController:navigation animated:YES];
}

- (IBAction)onCreateContactBackBtn:(id)sender {    
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)onSegmentChange:(id)sender {
    
    ContactsListDataSource *ds = nil;
    ContactsListDataSource *ds2 = nil;    
    UISegmentedControl *segmentedControl = sender;
    if (segmentedControl.selectedSegmentIndex == 1) {
        ds = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[status]=completed", CurrentUser.userId]];
        ds2 = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[status]=completed", CurrentUser.userId]];        
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        ds = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[assigned_to]=none", CurrentUser.userId]];        
        ds2 = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[assigned_to]=none", CurrentUser.userId]];                
    } else {
        ds = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[assigned_to]=%@", CurrentUser.userId]];        
        ds2 = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[assigned_to]=%@", CurrentUser.userId]];                
    }

    self.searchViewController.dataSource = ds2;
    self.dataSource = ds;
    [ds release];
}

//#pragma mark - UITableViewDelegate
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
//    // Return the number of rows in the section.
//    return [dataArray count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"ContactCell";
//    
//    // Dequeue or create a cell of the appropriate type.
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        [[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil];
//        cell = contactCell;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        self.contactCell = nil;
//    }
//    
//    NSDictionary *person = [dataArray objectAtIndex: indexPath.row];
//    // Configure the cell.
//    [(ContactCell*)cell setData: person];
//
//    return cell;
//}
//
//// Detect when player selects a section/row
//- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSDictionary *person = [dataArray objectAtIndex: indexPath.row];
//    
//    TTURLAction *action =  [[[TTURLAction actionWithURLPath:@"mh://contact"] 
//                             applyQuery:[NSDictionary dictionaryWithObject:person forKey:@"personData"]] 
//                            applyAnimated:YES];
//    [[TTNavigator navigator] openURLAction:action];
//    
////    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"mh://contact"]
////                                            applyQuery:[NSDictionary dictionaryWithObject:person forKey:@"personData"]]
////                             applyAnimated: YES];
//    
//}
//
//- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//	return 60.0f;
//}


@end
