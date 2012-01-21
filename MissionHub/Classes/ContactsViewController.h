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
@property BOOL assignMode;
@property (nonatomic, retain) IBOutlet UIButton *cancelBtn;
@property (nonatomic, retain) IBOutlet UIButton *assignBtn;
@property (nonatomic, retain) IBOutlet UISegmentedControl *filterSegmentedControl;

- (IBAction)onBackBtn:(id)sender;
- (IBAction)onSegmentChange:(id)sender;
- (IBAction)onAddContactBtn:(id)sender;
- (IBAction)onAssignBtn:(id)sender;
- (IBAction)onCancelBtn:(id)sender;

@end

@protocol SearchContactsControllerDelegate <NSObject>

- (void)searchContactsController:(ContactsViewController*)controller didSelectObject:(id)object;

@end

