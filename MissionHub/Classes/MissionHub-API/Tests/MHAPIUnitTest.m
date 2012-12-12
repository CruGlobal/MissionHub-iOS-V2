//
//  MHAPIUnitTest.m
//  MissionHub
//
//  Created by Michael Harrison on 12/10/12.
//
//

#import "MHAPIUnitTest.h"
#import "MHAPI.h"
#import "NSString+MHAdditions.h"

@implementation MHAPIUnitTest

@synthesize config;

- (void)setUp {
    [super setUp];
	
    
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testBuildURLShowRequest {
	
	NSString			*baseUrl	= @"https://www.missionhub.com/apis/v3";
	MHAPI				*api		= [MHAPI sharedInstance];
	NSError				*error;
	NSMutableDictionary	*showParams	= [NSMutableDictionary dictionaryWithObjects: [NSArray arrayWithObjects:@"questions,keyword",@"2",@"5", @"created_at", nil]
																	  forKeys: [NSArray arrayWithObjects:@"include", @"limit", @"offset", @"order", nil]
								   ];
	NSString			*result		= [api buildURLWith:baseUrl endpoint:MHAPIEndpointType_surveys method:MHAPIMethodType_index secret:@"my_secret" params:showParams error:&error];
	
	STAssertTrue([result containsSubstring: baseUrl],						@"Show request - base url not added correctly");
	STAssertTrue([result containsSubstring: @"/surveys?"],					@"Show request - Endpoint not added correctly");
	STAssertTrue([result containsSubstring: @"&include=questions,keyword"],	@"Show request - include param not added correctly");
	STAssertTrue([result containsSubstring: @"&limit=2"],					@"Show request - include param not added correctly");
	STAssertTrue([result containsSubstring: @"&offset=5"],					@"Show request - include param not added correctly");
	STAssertTrue([result containsSubstring: @"&order=created_at"],			@"Show request - include param not added correctly");
}

@end
