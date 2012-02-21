//
//  ContactsViewController.h
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"

@protocol SearchContactsControllerDelegate;

@interface ContactsViewController : TableViewController <TTSearchTextFieldDelegate, UIActionSheetDelegate, UISearchBarDelegate> {
    id<SearchContactsControllerDelegate> _delegate;
}

@property (nonatomic, assign) id<SearchContactsControllerDelegate> delegate;
@property (nonatomic, assign) BOOL shouldRefresh;
@property (nonatomic, assign) BOOL assignMode;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, retain) IBOutlet UIButton *cancelBtn;
@property (nonatomic, retain) IBOutlet UIButton *assignBtn;
@property (nonatomic, retain) IBOutlet UISegmentedControl *filterSegmentedControl;
@property (nonatomic, assign) BOOL isSearching;


- (IBAction)onBackBtn:(id)sender;
- (IBAction)onSegmentChange:(id)sender;
- (IBAction)onAddContactBtn:(id)sender;
- (IBAction)onAssignBtn:(id)sender;
- (IBAction)onCancelBtn:(id)sender;

@end

@protocol SearchContactsControllerDelegate <NSObject>

- (void)searchContactsController:(ContactsViewController*)controller didSelectObject:(id)object;

@end

