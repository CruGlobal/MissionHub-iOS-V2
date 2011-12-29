//
//  CreateContactViewController.h
//  MissionHub
//
//  Created by David Ang on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Three20/Three20.h>

@interface CreateContactViewController : TTTableViewController {
    UIView* _headerView;
    UIView* _footerView;
}

@property (nonatomic, retain) IBOutlet UIView* headerView;
@property (nonatomic, retain) IBOutlet UIView* footerView;

@end
