//
//  CreateContactViewController.m
//  MissionHub
//
//  Created by David Ang on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateContactViewController.h"
#import "Contact.h"

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
    
    QRootElement *root =     [[QRootElement alloc] initWithJSONFile:@"createContact"];
//    QSection *section = [[QSection alloc] init];
//    QLabelElement *label = [[QLabelElement alloc] initWithTitle:@"Hello" Value:@"world!"];
//    
//    [root addSection:section];
//    [section addElement:label];
    
    UINavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];
    [self presentModalViewController:navigation animated:YES];

}


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

}

@end


@implementation CreateContactQuickDialogDelegate 

- (void)onCreateContactBtn:(QButtonElement *)buttonElement {
    //[self loading:YES];
    Contact *info = [[Contact alloc] init];
    [self.root fetchValueIntoObject:info];
    
    [info create];
    
    NSLog(@"%@", info.firstName);
    
}
@end