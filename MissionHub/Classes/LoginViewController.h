//
//  LoginViewController.h
//  MissionHub
//
//  Created by David Ang on 12/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@interface LoginViewController : UIViewController {
    UIButton *aboutBtn;
}

- (IBAction)onAboutBtn:(id)sender;
- (IBAction)onLoginBtn:(id)sender;

@property (nonatomic, retain) IBOutlet UIButton *aboutBtn;

@end
