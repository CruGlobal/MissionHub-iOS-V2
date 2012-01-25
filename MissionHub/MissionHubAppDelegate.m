//
//  MissionHubAppDelegate.m
//  MissionHub
//
//  Created by David Ang on 12/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MissionHubAppDelegate.h"

#import "LoginViewController.h"
#import "MainViewController.h"
#import "ProfileViewController.h"
#import "ContactsViewController.h"
#import "ContactViewController.h"
#import "MessageController.h"
#import "CreateContactViewController.h"

#import "HJObjManager.h"

@implementation MissionHubAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize accessToken;
@synthesize config;
@synthesize imageManager;

//@synthesize loginViewController = _loginViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[TTURLRequestQueue mainQueue] setMaxContentLength:0];
    
    // Load config into an NSDictionary
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"config.plist"];
    config = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    //self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    //self.window.rootViewController = self.loginViewController;
    
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator setSupportsShakeToReload:YES];
    [navigator setPersistenceMode:TTNavigatorPersistenceModeAll];
    [navigator setWindow: self.window];

    TTURLMap *map = navigator.URLMap;
 
    [map from:@"*" toSharedViewController:[TTWebController class]];
    [map from:@"mh://login" toSharedViewController:[LoginViewController class]];    
    [map from:@"mh://main" toSharedViewController:[MainViewController class]];        
    [map from:@"mh://profile" toSharedViewController:[ProfileViewController class]];            
    [map from:@"mh://contacts" toViewController:[ContactsViewController class]];                
    [map from:@"mh://contact" toViewController:[ContactViewController class]];  
    [map from:@"mh://contact/(personId:)" toViewController:[ContactViewController class]];      
    [map from:@"mh://composeEmail?to=(composeEmailTo:)" toModalViewController:[MessageController alloc] selector:@selector(composeEmailTo:)];
    [map from:@"mh://composeSms?to=(composeSmsTo:)" toModalViewController:[MessageController alloc] selector:@selector(composeSmsTo:)];    
    [map from:@"mh://createContact" toViewController:[CreateContactViewController class]];  
    
    [map from:@"mh://nib/(loadFromNib:)" toSharedViewController:self];
    
//    [map            from: @"mh://contacts"
//                  parent: @"mh://main"
//        toViewController: [ContactsViewController class]
//                selector: nil
//              transition:UIViewAnimationTransitionCurlUp];

    if (! [navigator restoreViewControllers]) {
        [navigator openURLAction:[TTURLAction actionWithURLPath:@"mh://login"]];
        NSLog(@"opening...");
        
    }    

    // init HJObjManager, if you are using for full screen images, you'll need a smaller memory cache:
	imageManager = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:20];
	
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/MissionHub/"] ;
	HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
	imageManager.fileCache = fileCache;
	
	fileCache.fileCountLimit = 100;
	fileCache.fileAgeLimit = 60*60*24*7; // 1 week
	[fileCache trimCacheUsingBackgroundThread];


    [navigator.topViewController.navigationController setNavigationBarHidden:YES];    
	//[self.window.rootViewController pushViewController:webController animated:YES];
    //[self.window makeKeyAndVisible];
    
    // Check if we already have an accessToken
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CurrentUser.accessToken = [userDefaults stringForKey:@"accessToken"];	
    if (CurrentUser.accessToken) {
        NSLog(@"Found accesstoken: %@", CurrentUser.accessToken);
        
        NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
        NSString *requestUrl = [NSString stringWithFormat:@"%@/people/me.json?access_token=%@", baseUrl, CurrentUser.accessToken];

        TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
        request.cachePolicy = TTURLRequestCachePolicyNone;        
        request.response = [[TTURLJSONResponse alloc] init] ;
        [request send];
    }
    
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Loads the given viewcontroller from the nib
 */
- (UIViewController*)loadFromNib:(NSString *)nibName withClass:className {
    UIViewController* newController = [[NSClassFromString(className) alloc]
                                       initWithNibName:nibName bundle:nil];
       
    return newController;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Loads the given viewcontroller from the the nib with the same name as the
 * class
 */
- (UIViewController*)loadFromNib:(NSString*)className {
    return [self loadFromNib:className withClass:className];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    
    TTURLJSONResponse* response = request.response;
    NSLog(@"requestDidStartLoad:%@", response.rootObject);    
    //TTDASSERT([response.rootObject isKindOfClass:[NSArray class]]);

    NSDictionary *result = response.rootObject;
    [User sharedUser].data = [[result objectForKey:@"people"] objectAtIndex:0];
    
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://main"]];    
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    
    int status = [error code];
    NSLog(@"didFailLoadWithError HTTP return status code: %d", status);    

    if (status == 401) { // token has expired / invalid authentication
        NSLog(@"... access token has been invalidated");    
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        
        [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://login"]];    
    }
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
}

@end
