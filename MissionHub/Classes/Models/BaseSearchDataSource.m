//
//  BaseSearchRequestModel.m
//  MissionHub
//
//  Created by David Ang on 2/22/12.
//  Copyright (c) 2012 CCCI. All rights reserved.
//

#import "BaseSearchDataSource.h"
#import "MissionHubAppDelegate.h"
#import "TableSubtitleItemCell.h"

@implementation BaseSearchRequestModel

@synthesize dataArray;
@synthesize isSearching;
@synthesize filter;

- (id)init {
    if (self = [super init]) {     
        dataArray = [[NSMutableArray alloc] initWithCapacity:50];
        isSearching = NO;        
    }
    
    return self;
}
        
- (void)search:(NSString*)text {
    NSLog(@"searching...%@", text);
    [dataArray removeAllObjects];
    
    if (text.length > 2) {
        [[TTURLRequestQueue mainQueue] cancelRequestsWithDelegate:self];
        
        NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
        NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?term=%@&%@&org_id=%@&access_token=%@", baseUrl, [self urlPath], text, [self filter], CurrentUser.orgId, CurrentUser.accessToken];
        NSLog(@"making http GET request: %@", requestUrl);
        
        TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
        request.cachePolicy = TTURLRequestCachePolicyNone;
        //request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
        request.response = [[TTURLJSONResponse alloc] init];
        [request send];
        
        isSearching = YES;
        [_delegates makeObjectsPerformSelector:@selector(modelDidStartLoad:) withObject:self];
    } else {
        [_delegates makeObjectsPerformSelector:@selector(modelDidChange:) withObject:self];
    }
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    
    TTURLJSONResponse* response = request.response;
    if (request.respondedFromCache) {
        NSLog(@"requestDidFinishLoad from cache:%@", response.rootObject);
    } else {
        NSLog(@"requestDidFinishLoad:%@", response.rootObject);
    }
    
    [self handleRequestResult:response.rootObject identifier:request.userInfo];
    
    [super requestDidFinishLoad:request];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {    
    int status = [error code];
    NSLog(@"request error on identifier: %@. HTTP return status code: %d", request.userInfo, status);
    //NSLog(@"request didFailLoadWithError:%@", [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]);

    [super didFailLoadWithError:error];
}


- (void) handleRequestResult:(NSDictionary *)aResult identifier:(NSString*)aIdentifier {
    [dataArray removeAllObjects];
    
    NSDictionary *result = aResult;
    NSArray *contacts = [result objectForKey:@"contacts"];
    
    for (NSDictionary *tempDict in contacts) {
        NSDictionary *person = [tempDict objectForKey:@"person"];
        [dataArray addObject: person];
    }
    
    isSearching = NO;
    [_delegates makeObjectsPerformSelector:@selector(modelDidFinishLoad:) withObject:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTModel

- (BOOL)isLoading {
    return isSearching;
}

- (NSString*)urlPath { 
    // should assert
    return @"contacts/search.json";
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
// BaseSearchDataSource

@implementation BaseSearchDataSource

@synthesize requestModel;

- (id)init {
    if (self = [super init]) {
        requestModel = [[BaseSearchRequestModel alloc] init];
        self.model = requestModel;
    }
    return self;
}

- (void)dealloc {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewDataSource

- (id) tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView objectForRowAtIndexPath:indexPath];
}

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    
    if ([object isKindOfClass:[TTTableMoreButton class]]) {
        return [TTTableMoreButtonCell class];
    } else if ([object isKindOfClass:[TTTableSubtitleItem class]]) {
        return [TTTableSubtitleItemCell class];
    } else {
        return [super tableView:tableView cellClassForObject:object];
    }
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
    self.items = [NSMutableArray array];
    
    NSLog(@"BaseSearchDataSource::tableViewDidLoadModel");
    
    for (NSDictionary *person in requestModel.dataArray) {
        NSString *name = [person objectForKey:@"name"];
        NSString *status = [person objectForKey:@"status"];
        NSString *picture = [person objectForKey:@"picture"] ?  [person objectForKey:@"picture"]  : nil;
        UIImage *defaultImage = [UIImage imageNamed:@"default_contact.jpg"];
        
        if ([status isEqualToString:@"attempted_contact"]) {
            status = @"attempted contact";
        }
        
        TTTableSubtitleItem *item = [TTTableSubtitleItem itemWithText:name subtitle:status imageURL:(picture != nil ? picture : @"") defaultImage:defaultImage URL:nil accessoryURL:nil];
        item.userInfo = person;
        
        [_items addObject:item];
    }   
}

- (id<TTModel>)model {
    return requestModel;
}

- (void)search:(NSString*)text {
    [requestModel search:text];
}

- (NSString*)titleForLoading:(BOOL)reloading {
    return @"Searching...";
}

@end
