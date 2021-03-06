
#import "SearchTestController.h"
#import "MockDataSource.h"

@implementation SearchTestController

@synthesize delegate = _delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _delegate = nil;

        self.title = @"Search Test";
        self.dataSource = [[MockDataSource alloc] init];
    }
    return self;
}

- (void)dealloc {
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
    [super loadView];

    TTTableViewController* searchController = [[TTTableViewController alloc] init] ;
    searchController.dataSource = [[MockSearchDataSource alloc] initWithDuration:1.5] ;
    self.searchViewController = searchController;
    self.tableView.tableHeaderView = _searchController.searchBar;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    [_delegate searchTestController:self didSelectObject:object];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTSearchTextFieldDelegate

- (void)textField:(TTSearchTextField*)textField didSelectObject:(id)object {
    [_delegate searchTestController:self didSelectObject:object];
}

@end
