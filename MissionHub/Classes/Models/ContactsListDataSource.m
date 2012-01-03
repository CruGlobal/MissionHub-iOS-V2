//
//  ContactsListDataSource.m
//  MissionHub
//
//  Created by David Ang on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsListDataSource.h"
#import "MissionHubAppDelegate.h"
#import "TableSubtitleItemCell.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////
//// ContactsListRequestModel

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
    [_delegates perform:@selector(modelDidStartLoad:) withObject:self];
    
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
    
    [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier {
    [self makeHttpRequest:path params:urlParams identifier:aIdentifier];
}

- (void) makeHttpRequest:(NSString *)path params:(NSString*)aParams identifier:(NSString*)aIdentifier {
      
    //[self showActivityLabel];
}

//- (void)requestDidStartLoad:(TTURLRequest*)request {    
//    NSLog(@"start live http request: %@ method: %@", request.urlPath, request.httpMethod);    
//    
//    [super requestDidStartLoad: request];
//}

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

//- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
//    //[self hideActivityLabel];
//    
//    int status = [error code];
//    NSLog(@"request error on identifier: %@. HTTP return status code: %d", request.userInfo, status);
//    //NSLog(@"request didFailLoadWithError:%@", [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]);
//    [super didFailLoadWithError:error];
//}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////
//// ContactsListDataSource

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
// TTTableViewDataSource


- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    if ([object isKindOfClass:[TTTableSubtitleItem class]]) {
        return [TableSubtitleItemCell class];
    } else {
        return [super tableView:tableView cellClassForObject:object];
    }
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
    self.items = [NSMutableArray array];
    
    for (NSDictionary *person in contactList.filteredDataArray) {
        NSString *name = [person objectForKey:@"name"];
        NSString *status = [person objectForKey:@"status"];
        NSString *picture = [person objectForKey:@"picture"];        
        NSString *gender = [person objectForKey:@"gender"];

        UIImage *defaultImage = [UIImage imageNamed:@"facebook_male.gif"];
        if ([gender isKindOfClass:[NSString class]] && [gender isEqualToString:@"male"]) {
            defaultImage = [UIImage imageNamed:@"facebook_female.gif"];
        }

        TTTableSubtitleItem *item = [TTTableSubtitleItem itemWithText:name subtitle:status imageURL:picture defaultImage:defaultImage URL:nil accessoryURL:nil];
        item.userInfo = person;        
        
        [_items addObject:item];    
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
