//
//  CreateContactViewController.m
//  MissionHub
//
//  Created by David Ang on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateContactViewController.h"

@implementation CreateContactViewController

@synthesize headerView = _headerView;
@synthesize footerView = _footerView;


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Called both for NIB inits and manual inits
 */
-(id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
    if (self = [super initWithNibName:nibName bundle:bundle]) {
        self.title = @"DemoTableViewController";
        self.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle: @"Root"
                                          style: UIBarButtonItemStyleBordered
                                         target: nil
                                         action: nil] autorelease];
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc {
    TT_RELEASE_SAFELY(_footerView);
    TT_RELEASE_SAFELY(_headerView);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
//(NSInteger)section {
//    // Return the number of rows in the section.
//    return 10;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = (UITableViewCell *)[self.view viewWithTag: indexPath.row + 1];
//    return cell;
//}
	


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModelViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
    NSString * nibString = nil;
    
    if (self.nibName) {
        nibString = [@"NIB: " stringByAppendingString:self.nibName];
        
    } else {
        nibString = @"Called without a NIB";
    }
    
    UITableViewCell *firstNameCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    firstNameCell.textLabel.text = @"First Name:";

    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
    textField.placeholder = @"UITextField";

    [firstNameCell addSubview: textField];
    
    
    firstNameCell.textLabel.backgroundColor = [UIColor whiteColor];
                                         
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"TTTableViewController",
                       firstNameCell,
                       [TTTableTextItem itemWithText:@"This demonstates a table"],
                       [TTTableTextItem itemWithText:nibString],
                       
                       nil];
}

@end
