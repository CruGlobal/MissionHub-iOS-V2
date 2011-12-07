//
//  LoginViewController.h
//  MissionHub
//
//  Created by David Ang on 12/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    UIButton *aboutBtn;
}

- (IBAction)onAboutBtn:(id)sender;
- (IBAction)onLoginBtn:(id)sender;

@property (nonatomic, retain) IBOutlet UIButton *aboutBtn;

@end
