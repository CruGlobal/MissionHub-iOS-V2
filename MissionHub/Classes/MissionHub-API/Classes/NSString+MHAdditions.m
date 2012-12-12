//
//  NSString+MHAdditions.m
//  MissionHub
//
//  Created by Michael Harrison on 12/12/12.
//
//

#import "NSString+MHAdditions.h"

@implementation NSString (MHAdditions)

-(BOOL)containsSubstring:(NSString *)substring {
	
	if ([self rangeOfString:substring].location == NSNotFound) {
		
		return NO;
		
	} else {
		
		return YES;
		
	}
	
}

- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query {
	
	NSMutableArray* pairs = [NSMutableArray array];
	
	for (NSString* key in [query keyEnumerator]) {
		
		NSString* value = [query objectForKey:key];
		value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
		value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
		NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
		[pairs addObject:pair];
		
	}
	
	NSString* params = [pairs componentsJoinedByString:@"&"];
	
	if ([self rangeOfString:@"?"].location == NSNotFound) {
		
		return [self stringByAppendingFormat:@"?%@", params];
		
		
	} else {
		
		return [self stringByAppendingFormat:@"&%@", params];
		
	}
	
}

@end
