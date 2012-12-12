//
//  NSString+NSString_MHAdditions.h
//  MissionHub
//
//  Created by Michael Harrison on 12/12/12.
//
//

#import <Foundation/Foundation.h>

@interface NSString (MHAdditions)

-(BOOL)containsSubstring:(NSString *)substring;
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query;

@end
