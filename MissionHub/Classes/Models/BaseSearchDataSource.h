//
//  BaseSearchRequestModel.h
//  MissionHub
//
//  Created by David Ang on 2/22/12.
//  Copyright (c) 2012 CCCI. All rights reserved.
//


@interface BaseSearchRequestModel : TTURLRequestModel

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL           isSearching;

- (void)search:(NSString*)text;
- (void)handleRequestResult:(NSDictionary *)aResult identifier:(NSString*)aIdentifier;

// Child class must override
- (NSString*)urlPath; 

@end

@interface BaseSearchDataSource : TTListDataSource

@property (nonatomic, retain) BaseSearchRequestModel *requestModel;

@end
