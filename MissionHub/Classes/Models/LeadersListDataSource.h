//
//  LeadersListDataSource.h
//  MissionHub
//
//  Created by David Ang on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface  LeadersListRequestModel : TTURLRequestModel

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *filteredDataArray;

@end


@interface LeadersListDataSource : TTListDataSource

@property (nonatomic, retain) LeadersListRequestModel *leadersList;
@property BOOL selection;

- (id)initAsSelection:(BOOL)aSelection;

@end
