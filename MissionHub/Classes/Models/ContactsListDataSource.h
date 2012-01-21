//
//  ContactsListDataSource.h
//  MissionHub
//
//  Created by David Ang on 1/2/12.
//  Copyright (c) 2012 __26AM__. All rights reserved.
//

@interface  ContactsListRequestModel : TTURLRequestModel

@property (nonatomic, retain) NSString       *urlParams;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *filteredDataArray;


- (id)initWithParams:(NSString*)aParams;
- (void)search:(NSString*)text;

@end


@interface ContactsListDataSource : TTListDataSource

@property (nonatomic, retain) ContactsListRequestModel *contactList;
@property BOOL assignMode;

- (id)initWithParams:(NSString*)aParams;

@end
