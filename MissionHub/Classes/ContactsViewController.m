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
#import "LeadersListDataSource.h"
#import "LeaderSelectionViewController.h"

@implementation ContactsViewController

@synthesize delegate;
@synthesize assignMode;
@synthesize selectedIndexPath;
@synthesize cancelBtn;
@synthesize assignBtn;
@synthesize filterSegmentedControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) createModel {
    self.dataSource = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[assigned_to]=%@", CurrentUser.userId]];
}

- (void)loadView {
    [super loadView];

    TTTableViewController* searchController = [[TTTableViewController alloc] init];
    self.searchViewController = searchController;
    self.tableView.tableHeaderView = _searchController.searchBar;

    ContactsListDataSource *ds = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[assigned_to]=%@", CurrentUser.userId]];
    //searchController.dataSource = [[[MockSearchDataSource alloc] initWithDuration:1.5] autorelease];
    self.searchViewController.dataSource = ds;

    [self.tableView setFrame:CGRectMake(0, 33, 320, 398)];
    
    UILongPressGestureRecognizer* gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (id<TTTableViewDelegate>) createDelegate {
    return (id<TTTableViewDelegate>)[[TTTableViewDragRefreshDelegate alloc] initWithController:self];
}

- (void)handleGesture:(UILongPressGestureRecognizer *)recognizer {
    // only handle gestures when not in mass assign mode    
    if (!assignMode) {        
        if (recognizer.state == UIGestureRecognizerStateBegan) {    
            CGPoint p = [recognizer locationInView: self.tableView];
            selectedIndexPath = [self.tableView indexPathForRowAtPoint:p];
            if (selectedIndexPath != nil) {
                UIActionSheet *statusSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Status" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
                                                                otherButtonTitles:@"Promote to Leader", @"Cancel", nil];
                [statusSheet showInView:self.view];
            }
        } else if (recognizer.state == UIGestureRecognizerStateEnded) {
            NSLog(@"End");
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Promote to Leader"]) {
        NSLog(@"index row: %d",selectedIndexPath.row);
        NSDictionary *person = [((ContactsListDataSource*)self.dataSource).contactList.dataArray objectAtIndex:selectedIndexPath.row];
        
        [self makeHttpPutRequest:[NSString stringWithFormat:@"roles/%@", [person objectForKey:@"id"]] identifier:nil params:@"role=leader"];
    } 
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {

    [_delegate searchContactsController:self didSelectObject:object];
    selectedIndexPath = indexPath;

    TTTableSubtitleItem *item = (TTTableSubtitleItem*)object;

    if (assignMode == YES) {
        NSMutableDictionary *userInfo = item.userInfo;
        TTTableViewCell* cell = (TTTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [userInfo setObject:@"0" forKey:@"checked"];
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [userInfo setObject:@"1" forKey:@"checked"];
        }
    } else {
        // Check category and user is not drilled down to leaders contacts
        if (filterSegmentedControl.selectedSegmentIndex == 3 && [self.dataSource isKindOfClass:[LeadersListDataSource class]]) {
            // show leader listing
            self.dataSource = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[assigned_to]=%@", [item.userInfo objectForKey: @"id"]]];
        } else {
            TTURLAction *action =  [[[TTURLAction actionWithURLPath:@"mh://contact"]
                                     applyQuery:[NSDictionary dictionaryWithObject: item.userInfo forKey:@"personData"]]
                                    applyAnimated:YES];
            [[TTNavigator navigator] openURLAction:action];
        }
    }
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
    // Check category and user is currently viewing a leader's contacts
     if (filterSegmentedControl.selectedSegmentIndex == 3 && [self.dataSource isKindOfClass:[ContactsListDataSource class]]) {
         self.dataSource = [[LeadersListDataSource alloc] init];
     } else {
         [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://main"]];         
     }
}


- (IBAction)onAddContactBtn:(id)sender {
    //[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://nib/CreateContactViewController"]];
    //[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://createContact"]];

    QRootElement *root =     [[QRootElement alloc] initWithJSONFile:@"createContact"];
    UINavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];
    navigation.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewController:)];;

    [self presentModalViewController:navigation animated:YES];
}

- (IBAction)onAssignBtn:(id)sender {
    if (assignMode) {
        LeaderSelectionViewController *tableViewController = [[LeaderSelectionViewController alloc] initWithStyle:UITableViewStylePlain];

        UINavigationController *navigation =  [[UINavigationController alloc] initWithRootViewController:tableViewController ];
        navigation.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewController:)];;
        [navigation.navigationBar.topItem setTitle:@"Select a leader"];

        [self presentModalViewController:navigation animated:YES];

    } else {
        // Set assign mode to this view and the data source
        assignMode = YES;        
        ((ContactsListDataSource*)self.dataSource).assignMode = YES;

        [assignBtn setTitle:@"Select Leader" forState:UIControlStateNormal];
        [cancelBtn setHidden:NO];

        [self.tableView reloadData];
    }
}

- (IBAction)onCancelBtn:(id)sender {
    assignMode = NO;
    ((ContactsListDataSource*)self.dataSource).assignMode = NO;

    [assignBtn setTitle:@"Assign" forState:UIControlStateNormal];
    [cancelBtn setHidden:YES];

    [self.tableView reloadData];
}

- (IBAction)dismissModalViewController:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onSegmentChange:(id)sender {
    assignMode = NO;
    [assignBtn setTitle:@"Assign" forState:UIControlStateNormal];
    [assignBtn setHidden:NO];
    [cancelBtn setHidden:YES];
    
    //[[TTURLRequestQueue mainQueue] cancelRequestsWithDelegate:self];    

    ContactsListDataSource *ds = nil;
    ContactsListDataSource *ds2 = nil;

    LeadersListDataSource *ld = nil;
    LeadersListDataSource *ld2 = nil;

    UISegmentedControl *segmentedControl = sender;
    if (segmentedControl.selectedSegmentIndex == 1) {
        ds = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[status]=completed", CurrentUser.userId]];
        ds2 = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[status]=completed", CurrentUser.userId]];
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        ds = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[assigned_to]=none", CurrentUser.userId]];
        ds2 = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[assigned_to]=none", CurrentUser.userId]];
    } else if (segmentedControl.selectedSegmentIndex == 0) {
        ds = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[assigned_to]=%@", CurrentUser.userId]];
        ds2 = [[ContactsListDataSource alloc] initWithParams:[NSString stringWithFormat:@"filters[assigned_to]=%@", CurrentUser.userId]];
    } else {
        [assignBtn setHidden:YES];
        ld = [[LeadersListDataSource alloc] init];
        ld2 = [[LeadersListDataSource alloc] init];
    }

    if (ld == nil) {
        self.searchViewController.dataSource = ds2;
        self.dataSource = ds;
    } else {
        self.searchViewController.dataSource = ld2;
        self.dataSource = ld;
    }
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
