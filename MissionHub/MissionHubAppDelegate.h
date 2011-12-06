//
//  MissionHubAppDelegate.h
//  MissionHub
//
//  Created by David Ang on 12/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

//@class LoginViewController;

#define AppDelegate \
((MissionHubAppDelegate *)[UIApplication sharedApplication].delegate)

@interface MissionHubAppDelegate : NSObject <UIApplicationDelegate>


@property (nonatomic, retain) NSDictionary *config;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController*  navigationController;

//@property (nonatomic, retain) IBOutlet LoginViewController *loginViewController;

@end
