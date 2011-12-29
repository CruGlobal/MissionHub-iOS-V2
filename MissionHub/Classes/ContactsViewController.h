//
//  ContactsViewController.h
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@class ContactCell;

@interface ContactsViewController : BaseViewController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *dataArray;

- (IBAction)onBackBtn:(id)sender;
- (IBAction)onSegmentChange:(id)sender;
- (IBAction)onAddContactBtn:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) IBOutlet ContactCell *contactCell;

@end
