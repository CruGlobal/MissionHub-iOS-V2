//
//  BaseDataSource.h
//  MissionHub
//
//  Created by David Ang on 2/22/12.
//  Copyright (c) 2012 CCCI. All rights reserved.
//

@interface BaseURLRequestModel  : TTURLRequestModel

@property (nonatomic, strong) NSString       *urlParams;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger      currentPage;

- (id)initWithParams:(NSString*)aParams;
- (void)handleRequestResult:(NSDictionary *)aResult identifier:(NSString*)aIdentifier;

// Child class must override
- (NSString*)urlPath; 

@end

@interface BaseDataSource : TTListDataSource

@property (nonatomic, retain) BaseURLRequestModel *requestModel;


- (id)initWithParams:(NSString*)aParams;

@end

