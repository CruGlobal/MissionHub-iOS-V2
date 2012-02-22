//
//  ContactsListDataSource.m
//  MissionHub
//
//  Created by David Ang on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsListDataSource.h"
#import "TableSubtitleItemCell.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////
//// ContactsListRequestModel

@implementation ContactsListRequestModel

- (void) handleRequestResult:(NSDictionary *)aResult identifier:(NSString*)aIdentifier {
    NSDictionary *result = aResult;
    NSArray *contacts = [result objectForKey:@"contacts"];
    
    for (NSDictionary *tempDict in contacts) {
        NSDictionary *person = [tempDict objectForKey:@"person"];
        [self.dataArray addObject: person];
    }
}

- (NSString*)urlPath { 
    return @"contacts.json";
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

    NSLog(@"ContactListDataSource::tableViewDidLoadModel");

    for (NSDictionary *person in contactList.dataArray) {
        NSString *name = [person objectForKey:@"name"];
        NSString *status = [person objectForKey:@"status"];
        NSString *picture = [person objectForKey:@"picture"] ?  [person objectForKey:@"picture"]  : nil;
        NSString *gender = [person objectForKey:@"gender"];
        UIImage *defaultImage = [UIImage imageNamed:@"default_contact.jpg"];
//        if ([gender isKindOfClass:[NSString class]] && [gender isEqualToString:@"female"]) {
//            defaultImage = [UIImage imageNamed:@"facebook_female.gif"];
//        }

        if ([status isEqualToString:@"attempted_contact"]) {
            status = @"attempted contact";
        }

        TTTableSubtitleItem *item = [TTTableSubtitleItem itemWithText:name subtitle:status imageURL:(picture != nil ? picture : @"") defaultImage:defaultImage URL:nil accessoryURL:nil];
        item.userInfo = person;

        [_items addObject:item];
    }

    // See if we need to show the more button
    if (self.items.count == contactList.currentPage * 25) {
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



