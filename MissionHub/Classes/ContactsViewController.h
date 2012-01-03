//
//  ContactsViewController.h
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@protocol SearchContactsControllerDelegate;

@interface ContactsViewController : TTTableViewController <TTSearchTextFieldDelegate> {
    id<SearchContactsControllerDelegate> _delegate;
}

@property(nonatomic,assign) id<SearchContactsControllerDelegate> delegate;

- (IBAction)onBackBtn:(id)sender;
- (IBAction)onSegmentChange:(id)sender;
- (IBAction)onAddContactBtn:(id)sender;

@end

@protocol SearchContactsControllerDelegate <NSObject>

- (void)searchContactsController:(ContactsViewController*)controller didSelectObject:(id)object;

@end

