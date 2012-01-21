//
//  LeaderSelectionViewController.m
//  MissionHub
//
//  Created by David Ang on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeaderSelectionViewController.h"
#import "LeadersListDataSource.h"
#import "ContactsViewController.h"
#import "ContactsListDataSource.h"

@implementation LeaderSelectionViewController

- (void) createModel {
    self.dataSource = [[[LeadersListDataSource alloc] initAsSelection:YES] autorelease];
}


- (void)loadView {
    [super loadView];    
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    TTTableSubtitleItem *item = (TTTableSubtitleItem*)object;
    
    NSDictionary *leader = item.userInfo;
    
    ContactsViewController *contactsViewController = (ContactsViewController *)[[TTNavigator navigator] viewControllerForURL:@"mh://nib/ContactsViewController"];
    ContactsListDataSource *contactsListDataSource = contactsViewController.dataSource;

    NSInteger selectedCount = 0;
    for (TTTableSubtitleItem *item in contactsListDataSource.items) {
        if ([[item.userInfo objectForKey:@"checked"] intValue] == 1) {
            selectedCount++;
        }
    }        
    
    // open a alert with an OK and cancel button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: item.text message:[NSString stringWithFormat:@"Assign %d contacts to this leader?", selectedCount] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
    }
}
@end
