//
//  LoginViewController.h
//  MissionHub
//
//  Created by David Ang on 12/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UIWebViewDelegate> {
    UIButton *aboutBtn;
}

- (IBAction)onAboutBtn:(id)sender;
- (IBAction)onLoginBtn:(id)sender;

@property (nonatomic, retain) IBOutlet UIButton *aboutBtn;
@property (nonatomic, retain) UIWebView *fbWebView;
@property (nonatomic, retain) TTView *fbWebViewContainer;
@property BOOL accesssGranted;

@end
