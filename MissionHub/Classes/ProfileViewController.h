//
//  ProfileViewController.h
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *orgLabel;
@property (nonatomic, retain) IBOutlet UIImageView *placeHolderImageView;

- (IBAction)onLogoutBtn:(id)sender;
- (IBAction)onBackBtn:(id)sender;

@end
