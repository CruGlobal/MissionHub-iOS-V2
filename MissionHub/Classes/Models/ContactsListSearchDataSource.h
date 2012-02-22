//
//  ContactsListSearchDataSource.h
//  MissionHub
//
//  Created by David Ang on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseSearchDataSource.h"

@interface ContactsListSearchRequestModel : BaseSearchRequestModel

@end

@interface ContactsListSearchDataSource : BaseSearchDataSource 

@property (nonatomic, retain) ContactsListSearchRequestModel *contactList;

@end

