//
//  ContactsListSearchDataSource.m
//  MissionHub
//
//  Created by David Ang on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsListSearchDataSource.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////// search data source 

@implementation ContactsListSearchRequestModel

- (NSString*)urlPath {
    return @"contacts/search.json";
}

@end


@implementation ContactsListSearchDataSource

@synthesize contactList;



@end
