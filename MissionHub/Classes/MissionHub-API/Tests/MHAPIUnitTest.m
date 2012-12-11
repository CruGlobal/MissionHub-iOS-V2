//
//  MHAPIUnitTest.m
//  MissionHub
//
//  Created by Michael Harrison on 12/10/12.
//
//

#import "MHAPIUnitTest.h"
#import "MHAPI.h"
#import "MHConfiguration.h"

@implementation MHAPIUnitTest

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testBuildURL {
	
	NSString			*baseUrl	= [[MHConfiguration sharedInstance] objectForKey:@"api_url"];
	MHAPI				*api		= [MHAPI sharedInstance];
	NSError				*error;
	NSMutableDictionary	*showParams		= [NSMutableDictionary dictionaryWithObjects: [NSArray arrayWithObjects:@"questions,keyword",@"2",@"5", @"created_at", nil]
																	  forKeys: [NSArray arrayWithObjects:@"include", @"limit", @"offset", @"order", nil]
								   ];
	
	NSLog(@"%@", [api buildURLWith:MHAPIEndpointType_surveys method:MHAPIMethodType_index secret:@"my_secret" params:showParams error:&error]);
	NSLog(@"%@", [error localizedDescription]);
	STAssertTrue([[api buildURLWith:MHAPIEndpointType_surveys method:MHAPIMethodType_index secret:@"my_secret" params:showParams error:&error]
				  isEqualToString:[baseUrl stringByAppendingString:@"/surveys/?secret=my_secret&include=questions,keyword&limit=2&offset=5&order=created_at"]],
				 @"Show request not building correctly");
}

@end
