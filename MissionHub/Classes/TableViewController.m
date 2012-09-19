//
//  TableViewController.m
//  MissionHub
//
//  Created by David Ang on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"
#import "MissionHubAppDelegate.h"
#import "UIViewController+MJPopupViewController.h"
#import "TipViewController.h"

@implementation TableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *childClassName = NSStringFromClass([self class]);
    NSMutableString *nibName = [NSMutableString stringWithString:childClassName];
    if ([UIDevice instancesRespondToSelector:@selector(userInterfaceIdiom)]) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [nibName appendString:@"_ipad"];
        }
    }
    
    NSLog(@"initWithNibName: %@", childClassName);
    if([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"] != nil) {
        self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    } else {
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    // Determine the class name of this view controller using reflection.
    NSString *className = NSStringFromClass([self class]);
    [[EasyTracker sharedTracker] dispatchViewDidAppear:className];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults stringForKey:@"showGuides"] || ![userDefaults stringForKey:[NSString stringWithFormat:@"tip-%@", className]]) {        
        [userDefaults setObject:@"1" forKey:[NSString stringWithFormat:@"tip-%@", className]];
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"tips.plist"];
        NSDictionary *tips = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        NSString *tipText = [tips objectForKey:className];
        if(tipText) {
            TipViewController *tipViewController = [[TipViewController alloc] initWithNibName:@"TipViewController" bundle:nil];
            [self presentPopupViewController:tipViewController animationType:MJPopupViewAnimationFade];

            [tipViewController.textView setText:tipText];
        }
    }    
}

#pragma mark - HTTP convenience methods

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier {
    [self makeHttpRequest:path params:@"" identifier:aIdentifier];
}

- (void) makeHttpRequest:(NSString *)path params:(NSString*)aParams identifier:(NSString*)aIdentifier {
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?%@&org_id=%@&access_token=%@", baseUrl, path, aParams, CurrentUser.orgId, CurrentUser.accessToken];
    NSLog(@"making http GET request: %@", requestUrl);

    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.userInfo = aIdentifier;
    request.cachePolicy = TTURLRequestCachePolicyNone;
    request.response = [[TTURLJSONResponse alloc] init];
    [request send];
}

// Make an HTTP POST using NSString
- (void) makeHttpPostRequest:(NSString *)path identifier:(NSString*)aIdentifier postString:(NSString*)aPostString {
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?org_id=%@&access_token=%@", baseUrl, path, CurrentUser.orgId, CurrentUser.accessToken];
    NSLog(@"making http POST request: %@", requestUrl);

    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.userInfo = aIdentifier;
    request.response = [[TTURLJSONResponse alloc] init];
    request.httpMethod = @"POST";
    request.cachePolicy = TTURLRequestCachePolicyNone;
    request.contentType = @"application/x-www-form-urlencoded";

    NSLog(@"   post params: %@", aPostString);
    NSData *postData = [ NSData dataWithBytes: [ aPostString UTF8String ] length: [ aPostString length ] ];
    request.httpBody = postData;

    [request send];
}

// Make an HTTP POST using NSDictionary
- (void) makeHttpPostRequest:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostData {
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?org_id=%@&access_token=%@", baseUrl, path, CurrentUser.orgId, CurrentUser.accessToken];
    NSLog(@"making http POST request: %@", requestUrl);

    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.userInfo = aIdentifier;
    request.response = [[TTURLJSONResponse alloc] init];
    request.httpMethod = @"POST";
    request.cachePolicy = TTURLRequestCachePolicyNone;
    request.contentType = @"application/x-www-form-urlencoded";

    NSMutableString* postStr = [NSMutableString string];
    for (NSString *key in aPostData) {
        NSString *value = [aPostData objectForKey: key];
        [postStr appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];

        [request.parameters setObject:value forKey:key];
    }
    NSLog(@"   post params: %@", postStr);
    NSData *postData = [ NSData dataWithBytes: [ postStr UTF8String ] length: [ postStr length ] ];
    request.httpBody = postData;

    [request send];
}

// Make an HTTP PUT using NSString
- (void) makeHttpPutRequest:(NSString *)path identifier:(NSString*)aIdentifier params:(NSString*)aParams {
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?org_id=%@&access_token=%@", baseUrl, path, CurrentUser.orgId, CurrentUser.accessToken];
    NSLog(@"making http PUT request: %@", requestUrl);

    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.userInfo = aIdentifier;
    request.httpMethod = @"POST";
    request.response = [[TTURLJSONResponse alloc] init];
    request.cachePolicy = TTURLRequestCachePolicyNone;
    request.contentType = @"application/x-www-form-urlencoded";

    NSString *params = [NSString stringWithFormat:@"%@&_method=put", aParams];
    NSLog(@"   put params: %@", params);
    NSData *httpBody = [ NSData dataWithBytes: [ params UTF8String ] length: [ params length ] ];
    request.httpBody = httpBody;

    [request send];
}

- (void) makeHttpDeleteRequest:(NSString *)path identifier:(NSString*)aIdentifier params:(NSString*)aParams {
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?org_id=%@&access_token=%@", baseUrl, path, CurrentUser.orgId, CurrentUser.accessToken];
    NSLog(@"making http DELETE request: %@", requestUrl);

    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.userInfo = aIdentifier;
    request.httpMethod = @"POST";
    request.response = [[TTURLJSONResponse alloc] init];
    request.cachePolicy = TTURLRequestCachePolicyNone;
    request.contentType = @"application/x-www-form-urlencoded";

    NSString *params = [NSString stringWithFormat:@"%@&_method=delete", aParams];
    NSLog(@"   delete params: %@", params);
    NSData *httpBody = [ NSData dataWithBytes: [ params UTF8String ] length: [ params length ] ];
    request.httpBody = httpBody;

    [request send];
}

- (void)requestDidStartLoad:(TTURLRequest*)request {
    NSLog(@"start live http request: %@ method: %@", request.urlPath, request.httpMethod);
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {

    TTURLJSONResponse* response = request.response;
    if (request.respondedFromCache) {
        NSLog(@"requestDidFinishLoad from cache:%@", response.rootObject);
    } else {
        NSLog(@"requestDidFinishLoad:%@", response.rootObject);
    }

    NSDictionary *result = response.rootObject;
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *error = [result objectForKey:@"error"];
        if (error) {
            [[NiceAlertView alloc] initWithText: [error objectForKey:@"message"]];
        } else {
            [self handleRequestResult: result identifier:request.userInfo];
        }
    } else {
        NSLog(@"WARNING: API returned a none dictionary object.");
    }
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {

    int status = [error code];
    NSLog(@"request error on identifier: %@. HTTP return status code: %d", request.userInfo, status);
    //NSLog(@"request didFailLoadWithError:%@", [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]);
}

// Empty implementation, child class can override behavior to handle result from the HTTP request
- (void) handleRequestResult:(NSDictionary *)aResult identifier:(NSString*)aIdentifier {
}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error {
    [super model:model didFailLoadWithError:error];
    NSLog(@"didFailLoadWithError");
}

@end
