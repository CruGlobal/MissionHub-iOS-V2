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
@synthesize shouldRefresh;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) createModel {
    NSLog(@"ContactsViewController createModel");

    NSString *params = nil;

    if (filterSegmentedControl.selectedSegmentIndex == 1) {
        params = @"filters[status]=completed";
    } else if (filterSegmentedControl.selectedSegmentIndex == 2) {
        params = @"filters[assigned_to]=none";
    } else if (filterSegmentedControl.selectedSegmentIndex == 0) {
        params = [NSString stringWithFormat:@"filters[assigned_to]=%@", CurrentUser.userId];
    }

    //self.searchViewController.dataSource = [[ContactsListDataSource alloc] initWithParams:params];
    self.dataSource = [[ContactsListDataSource alloc] initWithParams:params];
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

    [[NSNotificationCenter defaultCenter] addObserverForName:@"contactUpdated" object:nil queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notif) {
                                                      shouldRefresh = YES;
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName:@"contactCreated" object:nil queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notif) {
                                                      filterSegmentedControl.selectedSegmentIndex = 2;
                                                      [self invalidateModel];
                                                  }];


}

- (id<TTTableViewDelegate>) createDelegate {
    return (id<TTTableViewDelegate>)[[TTTableViewDragRefreshDelegate alloc] initWithController:self];
}

- (void)handleGesture:(UILongPressGestureRecognizer *)recognizer {
    // only handle gestures when not in mass assign mode and leader listing
    if (!assignMode) {
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            // grab the index of the row where the user touch
            CGPoint p = [recognizer locationInView: self.tableView];
            // store the selected index path so we can use it to retrieve person from the contact list data array
            selectedIndexPath = [self.tableView indexPathForRowAtPoint:p];
            if (selectedIndexPath != nil) {
                if (filterSegmentedControl.selectedSegmentIndex != 3) {
                    UIActionSheet *statusSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Status" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
                                                                    otherButtonTitles:@"Promote to Leader", @"Cancel", nil];
                    [statusSheet showInView:self.view];
                } else {
                    // leaders listing
                    UIActionSheet *statusSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Status" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
                                                                    otherButtonTitles:@"Remove Leadership Role", @"Cancel", nil];
                    [statusSheet showInView:self.view];
                }
            }
        } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"index row: %d", selectedIndexPath.row);
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];

    if ([title isEqualToString:@"Promote to Leader"]) {
        
        NSMutableArray *contactsArray = ((ContactsListDataSource*)self.dataSource).contactList.dataArray;
        NSDictionary *person = [contactsArray objectAtIndex:selectedIndexPath.row];
        
        [self makeHttpPutRequest:[NSString stringWithFormat:@"roles/%@", [person objectForKey:@"id"]] identifier:nil params:@"role=leader"];
        
        [[NiceAlertView alloc] initWithText: [NSString stringWithFormat:@"%@ is now a leader", [person objectForKey:@"name"]]];
        
    } else if ([title isEqualToString:@"Remove Leadership Role"]) {
        
        NSMutableArray *leadersArray = ((LeadersListDataSource*)self.dataSource).leadersList.dataArray;
        NSDictionary *person = [leadersArray objectAtIndex:selectedIndexPath.row];

        [self makeHttpDeleteRequest:[NSString stringWithFormat:@"roles/%@", [person objectForKey:@"id"]] identifier:nil params:@"role=leader"];        
        [leadersArray removeObjectAtIndex:selectedIndexPath.row];
        
        [self.dataSource invalidate:YES];
        [self reload];
        
        [[NiceAlertView alloc] initWithText: [NSString stringWithFormat:@"You have removed %@ leadership's role", [person objectForKey:@"name"]]];        
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

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (shouldRefresh || [self.tableView.visibleCells count] == 0) {
        [self invalidateModel];
        shouldRefresh = NO;
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
    QSection *firstSection = [root getSectionForIndex:0];
    QBooleanElement *genderElement = [firstSection.elements objectAtIndex:2];
    genderElement.onImage = [UIImage imageNamed:@"maleicon.png"];
    genderElement.offImage = [UIImage imageNamed:@"femaleicon.png"];

    UINavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];
    navigation.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewController:)];;

    [self presentModalViewController:navigation animated:YES];
}

- (IBAction)onAssignBtn:(id)sender {
    if (assignMode) {
        // check if there are any contact that has been assigned
        ContactsListDataSource *contactsListDataSource = self.dataSource;
        NSInteger selectedCount = 0;
        for (TTTableSubtitleItem *item in contactsListDataSource.items) {
            if ([[item.userInfo objectForKey:@"checked"] intValue] == 1) {
                selectedCount++;
            }
        }
        if (selectedCount == 0) {
            [[NiceAlertView alloc] initWithText:@"Please mark at least 1 contact to assign to a new leader."];
            return;
        }

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

@end
