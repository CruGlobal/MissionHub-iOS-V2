//
//  MissionHubAppDelegate.h
//  MissionHub
//
//  Created by David Ang on 12/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <extThree20JSON/extThree20JSON.h>
#import "User.h"

//@class LoginViewController;

#define AppDelegate \
((MissionHubAppDelegate *)[UIApplication sharedApplication].delegate)

#define EXTJSON_SBJSON 

@class HJObjManager;

@interface MissionHubAppDelegate : NSObject <UIApplicationDelegate>

-(void)reachabilityChanged:(NSNotification*)note;

@property (nonatomic, retain) HJObjManager * imageManager;
@property (nonatomic, retain) NSDictionary *config;
@property (nonatomic, retain) NSString *accessToken;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController*  navigationController;


//@property (nonatomic, retain) IBOutlet LoginViewController *loginViewController;

@end
