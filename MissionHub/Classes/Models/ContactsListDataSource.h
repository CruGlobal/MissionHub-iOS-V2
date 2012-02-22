//
//  ContactsListDataSource.h
//  MissionHub
//
//  Created by David Ang on 1/2/12.
//  Copyright (c) 2012 CCCI. All rights reserved.
//

#import "BaseDataSource.h"
#import "BaseSearchDataSource.h"

@interface ContactsListRequestModel : BaseURLRequestModel

@end

@interface ContactsListDataSource : TTListDataSource

@property (nonatomic, retain) ContactsListRequestModel *contactList;
@property BOOL assignMode;

- (id)initWithParams:(NSString*)aParams;

@end


