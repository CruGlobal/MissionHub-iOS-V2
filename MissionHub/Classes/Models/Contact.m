//
//  Contact.m
//  MissionHub
//
//  Created by David Ang on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Contact.h"
#import "MissionHubAppDelegate.h"

@implementation Contact

@synthesize firstName;
@synthesize lastName;
@synthesize email;
@synthesize phone;
@synthesize gender;
@synthesize address1, address2, city, zip;

-(void) create:(void(^)(int))handler {
    [self makeHttpRequest:@"contacts"
               identifier:@"assign" postData: [NSDictionary dictionaryWithObjectsAndKeys:
                [NSDictionary dictionaryWithObjectsAndKeys: 
                 self.firstName, @"firstName", 
                 self.lastName, @"lastName",
                 self.gender, @"gender",
                 [NSDictionary dictionaryWithObjectsAndKeys: self.email, @"email", @"1", @"primary", nil], @"email_address",
                 [NSDictionary dictionaryWithObjectsAndKeys: self.phone, @"number", @"1", @"primary", nil], @"phone_number",
                 [NSDictionary dictionaryWithObjectsAndKeys: self.address1, @"address1", self.address2, @"address2", self.city, @"city", self.zip, @"zip", nil], @"current_address_attributes",                 
                 nil], @"person", 
                [NSDictionary dictionaryWithObjectsAndKeys: nil], @"answers", nil]];
    
    // NOTE: copying is very important if you'll call the callback asynchronously,
    // even with garbage collection!
    _completionHandler = [handler copy];
    

}

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostData {
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?org_id=%@&access_token=%@", baseUrl, path, CurrentUser.orgId, CurrentUser.accessToken];
    NSLog(@"making http POST request: %@", requestUrl);    
    
    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.userInfo = aIdentifier;
    request.response = [[[TTURLJSONResponse alloc] init] autorelease];
    request.httpMethod = @"POST";
    request.cachePolicy = TTURLRequestCachePolicyNone;
    
    NSString* json = (NSString*)[aPostData JSONRepresentation];
    NSData *jsonData = [NSData dataWithBytes:[json UTF8String] length:[json length]];
    [request setHttpBody:jsonData];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
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
    
    //[self handleRequestResult:(id*)response.rootObject identifier:request.userInfo];
    
    // Call completion handler.
    _completionHandler(1);
    
    // Clean up.
    [_completionHandler release];
    _completionHandler = nil;
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    int status = [error code];
    NSLog(@"request error on identifier: %@. HTTP return status code: %d", request.userInfo, status);
    //NSLog(@"request didFailLoadWithError:%@", [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]);
}

@end
