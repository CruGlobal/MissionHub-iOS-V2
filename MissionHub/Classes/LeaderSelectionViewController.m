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

@synthesize leaderId;

- (void) createModel {
    self.dataSource = [[LeadersListDataSource alloc] initAsSelection:YES];
}


- (void)loadView {
    [super loadView];    
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    TTTableSubtitleItem *item = (TTTableSubtitleItem*)object;
    leaderId = [item.userInfo objectForKey:@"id"]; // store the leader id selected by user
    
    ContactsViewController *contactsViewController = (ContactsViewController *)[[TTNavigator navigator] viewControllerForURL:@"mh://nib/ContactsViewController"];
    ContactsListDataSource *contactsListDataSource = contactsViewController.dataSource;

    NSInteger selectedCount = 0;
    for (TTTableSubtitleItem *item in contactsListDataSource.items) {
        if ([[item.userInfo objectForKey:@"checked"] intValue] == 1) {
            selectedCount++;
        }
    }        
    
    // open a alert with an OK and cancel button
    NSString *msg = @"Assign 1 contact to this leader?";
    if (selectedCount > 1) {
        msg = [NSString stringWithFormat:@"Assign %d contacts to this leader?", selectedCount];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: item.text message: msg delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        // Go back to the contact listing
        ContactsViewController *contactsViewController = (ContactsViewController *)[[TTNavigator navigator] viewControllerForURL:@"mh://nib/ContactsViewController"];
        ContactsListDataSource *contactsListDataSource = contactsViewController.dataSource;
        
        // Find out which contacts has been selected to assign
        for (TTTableSubtitleItem *item in contactsListDataSource.items) {
            NSDictionary *userInfo = item.userInfo;
            if ([[userInfo objectForKey:@"checked"] intValue] == 1) {
//                NSString *params = [NSString stringWithFormat:@"id=%@&type=leader&assign_to_id=%@", [userInfo objectForKey:@"id"], leaderId];
                //[self makeHttpRequest:@"contact_assignments" params:params identifier:@"contact_assignments"];
                
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [userInfo objectForKey:@"id"], @"id",
                                        leaderId, @"assign_to_id",
                                        @"leader", @"type", nil];
                
                [self makeHttpPostRequest:@"contact_assignments" identifier:@"contact_assignments" postData: params];
            }
        }
        
        
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
    }
}
@end
