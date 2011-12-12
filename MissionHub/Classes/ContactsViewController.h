//
//  ContactsViewController.h
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *dataArray;

- (IBAction)onBackBtn:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
