//
//  MHAPI.h
//  MissionHub
//
//  Created by Michael Harrison on 12/9/12.
//
//

#import <Foundation/Foundation.h>
#import "NSString+MHAdditions.h"

enum {
	MHAPIMethodType_index,
	MHAPIMethodType_show,
	MHAPIMethodType_update,
	MHAPIMethodType_create,
	MHAPIMethodType_delete
};
typedef NSUInteger MHAPIMethodType;

enum {
	MHAPIErrorCode_id_missing,
	MHAPIErrorCode_invalid_method
};
typedef NSUInteger MHAPIErrorCode;

#define MHAPIEndpointType_organizations	((NSString*)CFSTR("organizations"))
#define MHAPIEndpointType_people		((NSString*)CFSTR("people"))
#define MHAPIEndpointType_roles			((NSString*)CFSTR("roles"))
#define MHAPIEndpointType_surveys		((NSString*)CFSTR("surveys"))
typedef NSString * MHAPIEndpointType;

@interface MHAPI : NSObject

+(MHAPI*)sharedInstance;
-(NSString *)buildURLWith:(NSString *)baseUrl endpoint:(MHAPIEndpointType)endpoint method:(MHAPIMethodType)method secret:(NSString *)secret params:(NSDictionary *)params error:(NSError **)error;

@end
