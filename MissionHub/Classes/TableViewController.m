//
//  TableViewController.m
//  MissionHub
//
//  Created by David Ang on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"
#import "MissionHubAppDelegate.h"

@implementation TableViewController

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    // Determine the class name of this view controller using reflection.
    NSString *className = NSStringFromClass([self class]);
    [[EasyTracker sharedTracker] dispatchViewDidAppear:className];
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

// Make an HTTP POST using NSString
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
    NSDictionary *error = [result objectForKey:@"error"];
    if (error) {    
        [[NiceAlertView alloc] initWithText: [error objectForKey:@"message"]];
    } else {
        [self handleRequestResult: result identifier:request.userInfo];
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

@end
