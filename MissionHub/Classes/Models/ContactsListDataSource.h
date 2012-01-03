//
//  ContactsListDataSource.h
//  MissionHub
//
//  Created by David Ang on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class TTTwitterSearchFeedModel;

@interface  ContactsListRequestModel : TTURLRequestModel {
}

@property (nonatomic, retain)   NSString       *urlParams;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *filteredDataArray;

- (id)initWithParams:(NSString*)aParams;

@end

@interface ContactsListDataSource : TTSectionedDataSource {
     TTTwitterSearchFeedModel* _searchFeedModel;
}

- (id)initWithParams:(NSString*)aParams;

@property (nonatomic, readonly) ContactsListRequestModel *contactList;

@end
