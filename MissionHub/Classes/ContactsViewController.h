//
//  ContactsViewController.h
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@protocol SearchContactsControllerDelegate;

@class ContactCell;

@interface ContactsViewController : TTTableViewController <TTSearchTextFieldDelegate> {
    id<SearchContactsControllerDelegate> _delegate;
}

@property(nonatomic,assign) id<SearchContactsControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *dataArray;

- (IBAction)onBackBtn:(id)sender;
- (IBAction)onSegmentChange:(id)sender;
- (IBAction)onAddContactBtn:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) IBOutlet ContactCell *contactCell;


@end

@protocol SearchContactsControllerDelegate <NSObject>

- (void)searchContactsController:(ContactsViewController*)controller didSelectObject:(id)object;

@end

