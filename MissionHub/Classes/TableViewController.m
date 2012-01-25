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

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier postString:(NSString*)aPostString {
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

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostData {
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
    
    [self handleRequestResult:response.rootObject identifier:request.userInfo];
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