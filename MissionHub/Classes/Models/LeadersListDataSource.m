//
//  LeadersListDataSource.m
//  MissionHub
//
//  Created by David Ang on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeadersListDataSource.h"
#import "MissionHubAppDelegate.h"
#import "TableSubtitleItemCell.h"

@implementation LeadersListRequestModel

@synthesize dataArray, filteredDataArray;

- (id)init {
    if (self = [super init]) {
        self.dataArray = [[NSMutableArray alloc] initWithCapacity:50];
    }

    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    //[_delegates perform:@selector(modelDidStartLoad:) withObject:self];

    if (!self.isLoading) {

        [dataArray removeAllObjects];

        NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
        NSString *requestUrl = [NSString stringWithFormat:@"%@/people/leaders?&org_id=%@&access_token=%@", baseUrl, CurrentUser.orgId, CurrentUser.accessToken];
        NSLog(@"making http GET request: %@", requestUrl);

        TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
        request.cachePolicy = TTURLRequestCachePolicyNone;
        //request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
        request.response = [[TTURLJSONResponse alloc] init];
        [request send];

    }
}

- (void)search:(NSString*)text {
    NSLog(@"searching...%@", text);
    [filteredDataArray removeAllObjects];
    
    if (text.length) {
        text = [text lowercaseString];
        for (NSDictionary *person in dataArray) {
            NSString *name = [person objectForKey:@"name"];
            if ([[name lowercaseString] rangeOfString:text].location == 0) {
                [filteredDataArray addObject:person];
                NSLog(@"person found");
            }
        }
    }
    
    [_delegates makeObjectsPerformSelector:@selector(modelDidFinishLoad:) withObject:self];   
}

- (void) handleRequestResult:(NSDictionary*)aResult identifier:(NSString*)aIdentifier {

    NSDictionary *result = aResult;
    NSArray *leaders = [result objectForKey:@"leaders"];

    for (NSDictionary *tempDict in leaders) {
        [dataArray addObject: tempDict];
    }

   [_delegates makeObjectsPerformSelector:@selector(modelDidFinishLoad:) withObject:self];
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

@end

@implementation LeadersListDataSource

@synthesize leadersList;
@synthesize selection;

- (id)initAsSelection:(BOOL)aSelection {
    selection = aSelection;
    return [self init]; 
}

- (id)init {
    if (self = [super init]) {
        leadersList = [[LeadersListRequestModel alloc] init];
        self.model = leadersList;
    }
    return self;
}

- (void)dealloc {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewDataSource


- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    if ([object isKindOfClass:[TTTableSubtitleItem class]]) {
        if (selection) {
            return [TTTableSubtitleItemCell class];
        } else {
            return [TableSubtitleItemCell class];
        }
    } else {
        return [super tableView:tableView cellClassForObject:object];
    }
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
    self.items = [NSMutableArray array];

    NSLog(@"tableViewDidLoadModel");

    for (NSDictionary *person in leadersList.dataArray) {
        NSString *name = [person objectForKey:@"name"];
        NSString *picture = [person objectForKey:@"picture"];
        NSString *gender = [person objectForKey:@"gender"];
        NSString *numContacts = [NSString stringWithFormat:@"%@ contacts", [person objectForKey:@"num_contacts"]];

        UIImage *defaultImage = [UIImage imageNamed:@"default_contact.jpg"];
        TTTableSubtitleItem *item = [TTTableSubtitleItem itemWithText:name subtitle:numContacts
                                                             imageURL:(picture ? picture : @"") defaultImage:defaultImage URL:nil accessoryURL:nil];
        item.userInfo = person;
        [_items addObject:item];
    }
}

- (id<TTModel>)model {
    return leadersList;
}

- (NSString*)titleForLoading:(BOOL)reloading {
    return @"Loading leaders...";
}
@end
