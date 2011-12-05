//
//  MissionHubAppDelegate.m
//  MissionHub
//
//  Created by David Ang on 12/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MissionHubAppDelegate.h"

#import "LoginViewController.h"

@implementation MissionHubAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
//@synthesize loginViewController = _loginViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    //self.window.rootViewController = self.loginViewController;
    
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator setSupportsShakeToReload:YES];
    [navigator setPersistenceMode:TTNavigatorPersistenceModeAll];
    [navigator setWindow: self.window];


    TTURLMap *map = navigator.URLMap;
    [map from:@"*" toViewController:[TTWebController class]];
    [map from:@"mh://login" toSharedViewController:[LoginViewController class]];    

    if (! [navigator restoreViewControllers]) {
        [navigator openURLAction:[TTURLAction actionWithURLPath:@"mh://login"]];
        NSLog(@"opening...");
        
    }

    [navigator.topViewController.navigationController setNavigationBarHidden:YES];    
	//[self.window.rootViewController pushViewController:webController animated:YES];
    //[self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */ 
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
    NSLog(@"handleOpenUrl");
    
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
    return YES;
}

- (void)dealloc
{
    //[_loginViewController release];
    [_window release];
    [super dealloc];
}

@end
