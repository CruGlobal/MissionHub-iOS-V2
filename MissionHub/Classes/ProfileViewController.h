//
//  ProfileViewController.h
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@class HJManagedImageV;

@interface ProfileViewController : UIViewController

@property (nonatomic, retain) IBOutlet HJManagedImageV *profileImageView;

- (IBAction)onLogoutBtn:(id)sender;
- (IBAction)onBackBtn:(id)sender;

@end
