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

@synthesize dataArray;
@synthesize filteredDataArray;
@synthesize urlParams;
@synthesize page;

- (id)initWithParams:(NSString*)aParams {
    if (self = [super init]) {

        dataArray = [[NSMutableArray alloc] initWithCapacity:50];
        filteredDataArray = [[NSMutableArray alloc] initWithCapacity:50];
        urlParams = aParams;
        NSLog(@"initWithParams: %@", self.urlParams);
    }

    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    NSLog(@"url params is: %@", self.urlParams);
    //[_delegates perform:@selector(modelDidStartLoad:) withObject:self];

    if (!self.isLoading && TTIsStringWithAnyText(self.urlParams)) {
        if (more) {
            page += 1;
        } else {
            page = 1;
            [dataArray removeAllObjects];
            [filteredDataArray removeAllObjects];
        }

        NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
        NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?%@&start=%d&limit=25&org_id=%@&access_token=%@", baseUrl, @"contacts.json", self.urlParams, (page - 25) * 100, CurrentUser.orgId, CurrentUser.accessToken];
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
            }
        }
    }

    //[_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}

- (void) handleRequestResult:(NSDictionary *)aResult identifier:(NSString*)aIdentifier {

    NSDictionary *result = aResult;
    NSArray *contacts = [result objectForKey:@"contacts"];

    for (NSDictionary *tempDict in contacts) {
        NSDictionary *person = [tempDict objectForKey:@"person"];
        [dataArray addObject: person];
        [filteredDataArray addObject:person];
    }

    //[_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
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

/////////////////////////////////////////////////////////////////////////////////////////////////////
//// ContactsListDataSource

@implementation ContactsListDataSource

@synthesize contactList;
@synthesize assignMode;

- (id)initWithParams:(NSString*)aParams {
    if (self = [super init]) {
        contactList = [[ContactsListRequestModel alloc] initWithParams:aParams];
        assignMode = NO;
        self.model = contactList;
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

- (void)tableView:(UITableView *)tableView cell:(UITableViewCell *)cell willAppearAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == self.items.count - 1 && [cell isKindOfClass:[TTTableMoreButtonCell class]]) {
		TTTableMoreButton* moreBtn = [(TTTableMoreButtonCell *)cell object];
		moreBtn.isLoading = YES;
		[(TTTableMoreButtonCell *)cell setAnimating:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[self.model load:TTURLRequestCachePolicyDefault more:YES];		
        NSLog(@"showing more...");
	} else {
        TTTableSubtitleItem *item = [_items objectAtIndex:indexPath.row];
        NSDictionary *userInfo = (NSDictionary*)item.userInfo;
        
        if (assignMode) {
            if ([userInfo objectForKey:@"checked"] == @"1") {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
}

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {

    if ([object isKindOfClass:[TTTableMoreButton class]]) {        
        return [TTTableMoreButtonCell class];        
    } else if ([object isKindOfClass:[TTTableSubtitleItem class]]) {
            return [TableSubtitleItemCell class];
    } else {
        return [super tableView:tableView cellClassForObject:object];
    }
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
    self.items = [NSMutableArray array];

    NSLog(@"tableViewDidLoadModel");

    for (NSDictionary *person in contactList.filteredDataArray) {
        NSString *name = [person objectForKey:@"name"];
        NSString *status = [person objectForKey:@"status"];
        NSString *picture = [person objectForKey:@"picture"] ?  [person objectForKey:@"picture"]  : nil;
        NSString *gender = [person objectForKey:@"gender"];

        UIImage *defaultImage = [UIImage imageNamed:@"facebook_male.gif"];
        if ([gender isKindOfClass:[NSString class]] && [gender isEqualToString:@"female"]) {
            defaultImage = [UIImage imageNamed:@"facebook_female.gif"];
        }

        TTTableSubtitleItem *item = [TTTableSubtitleItem itemWithText:name subtitle:status imageURL:(picture != nil ? picture : @"") defaultImage:defaultImage URL:nil accessoryURL:nil];
        item.userInfo = person;

        [_items addObject:item];
    }
    
    // See if we need to show the more button
    if (self.items.count == contactList.page * 25) {
        TTTableMoreButton  *moreBtn = [TTTableMoreButton itemWithText:@"More"];
        [_items addObject:moreBtn];
    }
}

- (id<TTModel>)model {
    return contactList;
}

- (void)search:(NSString*)text {
    [contactList search:text];
}

- (NSString*)titleForLoading:(BOOL)reloading {
    return @"Loading contacts...";
}


@end

