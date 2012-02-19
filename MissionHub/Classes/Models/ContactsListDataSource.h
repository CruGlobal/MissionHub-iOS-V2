//
//  ContactsListDataSource.h
//  MissionHub
//
//  Created by David Ang on 1/2/12.
//  Copyright (c) 2012 __26AM__. All rights reserved.
//

@interface  ContactsListRequestModel : TTURLRequestModel

@property (nonatomic, strong) NSString       *urlParams;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *filteredDataArray;
@property (nonatomic, assign) NSInteger      page;


- (id)initWithParams:(NSString*)aParams;
- (void)search:(NSString*)text;

@end


@interface ContactsListDataSource : TTListDataSource

@property (nonatomic, retain) ContactsListRequestModel *contactList;
@property BOOL assignMode;

- (id)initWithParams:(NSString*)aParams;

@end
