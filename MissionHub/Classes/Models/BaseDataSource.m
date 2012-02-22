//
//  BaseDataSource.m
//  MissionHub
//
//  Created by David Ang on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDataSource.h"
#import "MissionHubAppDelegate.h"

@implementation BaseURLRequestModel

@synthesize dataArray;
@synthesize urlParams;
@synthesize currentPage;

- (id)initWithParams:(NSString*)aParams {
    NSLog(@"BaseURLRequestModel::initWithParams %@", aParams);    

    if (self = [super init]) {        
        dataArray = [[NSMutableArray alloc] initWithCapacity:50];
        urlParams = aParams;
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    NSLog(@"BaseURLRequestModel::load. url params is: %@", self.urlParams);
    
    if (!self.isLoading && TTIsStringWithAnyText(self.urlParams)) {
        if (more) {
            currentPage += 1;
        } else {
            currentPage = 1;
            [dataArray removeAllObjects];
        }
        
        NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
        NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?%@&start=%d&limit=25&org_id=%@&access_token=%@", baseUrl, [self urlPath], self.urlParams, (currentPage - 1) * 25, CurrentUser.orgId, CurrentUser.accessToken];
        NSLog(@"making http GET request: %@", requestUrl);
        
        TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
        request.cachePolicy = TTURLRequestCachePolicyNone;
        //request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
        request.response = [[TTURLJSONResponse alloc] init];
        [request send];

        [_delegates makeObjectsPerformSelector:@selector(modelDidStartLoad:) withObject:self];
    }
}

//- (void)requestDidStartLoad:(TTURLRequest*)request {
//    NSLog(@"start live http request: %@ method: %@", request.urlPath, request.httpMethod);
//
//    [super requestDidStartLoad: request];
//}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    
    TTURLJSONResponse* response = request.response;
    if (request.respondedFromCache) {
        NSLog(@"requestDidFinishLoad from cache:%@", response.rootObject);
    } else {
        NSLog(@"requestDidFinishLoad:%@", response.rootObject);
    }

    [super requestDidFinishLoad:request];
    
    [self handleRequestResult:response.rootObject identifier:request.userInfo];
    
    [_delegates makeObjectsPerformSelector:@selector(modelDidFinishLoad:) withObject:self];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    [super didFailLoadWithError:error];
 
    int status = [error code];
    NSLog(@"request error on identifier: %@. HTTP return status code: %d", request.userInfo, status);
    //NSLog(@"request didFailLoadWithError:%@", [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]);
}


- (void) handleRequestResult:(NSDictionary *)aResult identifier:(NSString*)aIdentifier {
}

- (NSString*)urlPath { 
    return nil;
}

@end

