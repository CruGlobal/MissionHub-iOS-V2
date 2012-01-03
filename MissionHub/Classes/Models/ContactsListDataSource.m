//
//  ContactsListDataSource.m
//  MissionHub
//
//  Created by David Ang on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsListDataSource.h"
#import "MissionHubAppDelegate.h"

@implementation ContactsListRequestModel

@synthesize dataArray, filteredDataArray, urlParams;

- (id)initWithParams:(NSString*)aParams {
    if (self = [super init]) {

        self.dataArray = [[NSMutableArray alloc] initWithCapacity:50];                
        self.filteredDataArray = [[NSMutableArray alloc] initWithCapacity:50];                
        self.urlParams = aParams;
        NSLog(@"initWithParams: %@", self.urlParams);
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
    TT_RELEASE_SAFELY(dataArray);
    [super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    NSLog(@"url params is: %@", self.urlParams);
    if (!self.isLoading && TTIsStringWithAnyText(self.urlParams)) {

        [dataArray removeAllObjects];
        [filteredDataArray removeAllObjects];
        
        NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
        NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?%@&access_token=%@", baseUrl, @"contacts.json", self.urlParams, CurrentUser.accessToken];
        NSLog(@"making http GET request: %@", requestUrl);    
        
        TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
        request.cachePolicy = TTURLRequestCachePolicyNone;
        //request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
        request.response = [[[TTURLJSONResponse alloc] init] autorelease];
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
            }
        }
    }
    
    [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}

- (void) handleRequestResult:(id *)aResult identifier:(NSString*)aIdentifier {
    
    NSDictionary *result = (NSDictionary *)aResult;
    NSArray *contacts = [result objectForKey:@"contacts"];
    
    for (NSDictionary *tempDict in contacts) {
        NSDictionary *person = [tempDict objectForKey:@"person"];
        [dataArray addObject: person];
        [filteredDataArray addObject:person];
    }
}

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier {
    [self makeHttpRequest:path params:urlParams identifier:aIdentifier];
}

- (void) makeHttpRequest:(NSString *)path params:(NSString*)aParams identifier:(NSString*)aIdentifier {
      
    //[self showActivityLabel];
}

- (void)requestDidStartLoad:(TTURLRequest*)request {    
    NSLog(@"start live http request: %@ method: %@", request.urlPath, request.httpMethod);    
    
    [super requestDidStartLoad: request];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    //[self hideActivityLabel];
    
    TTURLJSONResponse* response = request.response;
    if (request.respondedFromCache) {
        NSLog(@"requestDidFinishLoad from cache:%@", response.rootObject);   
    } else {
        NSLog(@"requestDidFinishLoad:%@", response.rootObject);   
    }
    
    [self handleRequestResult:(id*)response.rootObject identifier:request.userInfo];
    
    [super requestDidFinishLoad:request];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    //[self hideActivityLabel];
    
    int status = [error code];
    NSLog(@"request error on identifier: %@. HTTP return status code: %d", request.userInfo, status);
    //NSLog(@"request didFailLoadWithError:%@", [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]);
    [super didFailLoadWithError:error];
}

@end


@implementation ContactsListDataSource

@synthesize contactList;

- (id)initWithParams:(NSString*)aParams {
    if (self = [super init]) {
        contactList = [[ContactsListRequestModel alloc] initWithParams:aParams];
        self.model = contactList;
    }
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(contactList);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UITableViewDataSource

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView {
    return [TTTableViewDataSource lettersForSectionsWithSearch:NO summary:NO];
} 

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewDataSource

- (void)tableViewDidLoadModel:(UITableView*)tableView {
    self.items = [NSMutableArray array];
    self.sections = [NSMutableArray array];
    
    NSMutableDictionary* groups = [NSMutableDictionary dictionary];
    
    for (NSDictionary *person in contactList.filteredDataArray) {
        NSString *name = [person objectForKey:@"name"];
        
        NSString* letter = [NSString stringWithFormat:@"%C", [name characterAtIndex:0]];
        NSMutableArray* section = [groups objectForKey:letter];
        if (!section) {
            section = [NSMutableArray array];
            [groups setObject:section forKey:letter];
        }
        
  
        TTTableSubtitleItem *item = [TTTableSubtitleItem itemWithText:[person objectForKey:@"name"] subtitle:[person objectForKey:@"status"] imageURL:[person objectForKey:@"picture"] URL: nil];
        item.userInfo = person;
        
        [section addObject:item];        
    }

    NSArray* letters = [groups.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (NSString* letter in letters) {
        NSArray* items = [groups objectForKey:letter];
        [_sections addObject:letter];
        [_items addObject:items];
    }
}

- (id<TTModel>)model {
    return contactList;
}

- (void)search:(NSString*)text {
    [contactList search:text];
}

- (NSString*)titleForLoading:(BOOL)reloading {
    return @"Loading content...";
}


@end
