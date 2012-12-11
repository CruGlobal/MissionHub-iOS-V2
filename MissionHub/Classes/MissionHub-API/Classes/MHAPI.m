//
//  MHAPI.m
//  MissionHub
//
//  Created by Michael Harrison on 12/9/12.
//
//

#import "MHAPI.h"
#import "MHConfiguration.h"
#import "Three20/Three20+Additions.h"

@implementation MHAPI

static MHAPI* _sharedMHAPI = nil;

+(MHAPI*)sharedInstance {
	
	if (_sharedMHAPI == nil) {
	
		_sharedMHAPI = [[self alloc] init];
		
	}
	
	return _sharedMHAPI;
	
}

-(NSString *)buildURLWith:(MHAPIEndpointType)endpoint method:(MHAPIMethodType)method secret:(NSString *)secret params:(NSDictionary *)params error:(NSError **)error {
	
	NSString			*baseUrl	= [[MHConfiguration sharedInstance] objectForKey:@"api_url"];
	NSString			*requestUrl	= [baseUrl stringByAppendingFormat:@"/%@", endpoint];
	NSString			*contentType= nil;
	NSString			*httpMethod	= @"GET";
	NSMutableDictionary	*parameters	= ( params == nil ?
									   [[NSMutableDictionary alloc] init] :
									   [[NSMutableDictionary alloc] initWithDictionary:params copyItems:YES] );
	id					idParameter = nil;
	
	//remove id (if it exists) from parameters for url contruction
	if ([parameters objectForKey:@"id"]) {
		
		idParameter	= [parameters objectForKey:@"id"];
		[parameters removeObjectForKey:@"id"];
		
	}
	
	//add secret to parameters for url contruction
	[parameters setObject:secret forKey:@"secret"];
	NSLog(@"%@", [MHConfiguration sharedInstance]);
	switch (method) {
		
		case MHAPIMethodType_index:
			
			requestUrl = [requestUrl stringByAddingQueryDictionary:parameters];
			
			break;
		
		case MHAPIMethodType_show:
			
			if (idParameter != nil) {
				
				requestUrl	= [requestUrl stringByAppendingFormat:@"/%@", idParameter];
				requestUrl	= [requestUrl stringByAddingQueryDictionary:parameters];
				
			} else {
				
				//error message
				NSLog(@"MissionHub API Error - Using the show method on the %@ endpoint requires an id. Please provide an ID for this API call. %@", endpoint, requestUrl);
				
				NSMutableDictionary* details = [NSMutableDictionary dictionary];
				[details setValue:[NSString stringWithFormat:@"MissionHub API Error - Using the show method on the %@ endpoint requires an id. Please provide an ID for this API call. %@", endpoint, requestUrl] forKey:NSLocalizedDescriptionKey];
				*error		= [NSError errorWithDomain:@"MissionHub API" code:MHAPIErrorCode_id_missing userInfo:details];
				
				return nil;
				
			}
			
			break;
			
		case MHAPIMethodType_update:
			
			if (idParameter != nil) {
				
				httpMethod	= @"PUT";
				requestUrl	= [requestUrl stringByAppendingFormat:@"/%@", idParameter];
				requestUrl	= [requestUrl stringByAddingQueryDictionary:parameters];
				
				//construct json for body from params
				contentType = @"application/json";
				
			} else {
				
				//error message
				NSLog(@"MissionHub API Error - Using the update method on the %@ endpoint requires an id. Please provide an ID for this API call. %@", endpoint, requestUrl);
				
				NSMutableDictionary* details = [NSMutableDictionary dictionary];
				[details setValue:[NSString stringWithFormat:@"MissionHub API Error - Using the update method on the %@ endpoint requires an id. Please provide an ID for this API call. %@", endpoint, requestUrl] forKey:NSLocalizedDescriptionKey];
				*error		= [NSError errorWithDomain:@"MissionHub API" code:MHAPIErrorCode_id_missing userInfo:details];
				
				return nil;
				
			}
			
			break;
			
		case MHAPIMethodType_create:
			
			httpMethod	= @"POST";
			requestUrl	= [requestUrl stringByAddingQueryDictionary:parameters];
			
			//construct json for body from params
			contentType = @"application/json";
			
			break;
			
		case MHAPIMethodType_delete:
			
			if (idParameter != nil) {
			
				httpMethod	= @"DELETE";
				requestUrl	= [requestUrl stringByAppendingFormat:@"/%@", idParameter];
				requestUrl	= [requestUrl stringByAddingQueryDictionary:parameters];
					
			} else {
				
				//error message
				NSLog(@"MissionHub API Error - Using the delete method on the %@ endpoint requires an id. Please provide an ID for this API call. %@", endpoint, requestUrl);
				
				NSMutableDictionary* details = [NSMutableDictionary dictionary];
				[details setValue:[NSString stringWithFormat:@"MissionHub API Error - Using the delete method on the %@ endpoint requires an id. Please provide an ID for this API call. %@", endpoint, requestUrl] forKey:NSLocalizedDescriptionKey];
				*error		= [NSError errorWithDomain:@"MissionHub API" code:MHAPIErrorCode_id_missing userInfo:details];
				
				return nil;
				
			}
			
			break;
			
		default:
			
			//error message
			NSLog(@"MissionHub API Error - A valid request method is required to make an API request. Please provide one of the following methods (index, show, update, create and delete) for this API call. %@", requestUrl);
			
			NSMutableDictionary* details = [NSMutableDictionary dictionary];
			[details setValue:[NSString stringWithFormat:@"MissionHub API Error - A valid request method is required to make an API request. Please provide one of the following methods (index, show, update, create and delete) for this API call. %@", requestUrl] forKey:NSLocalizedDescriptionKey];
			*error		= [NSError errorWithDomain:@"MissionHub API" code:MHAPIErrorCode_invalid_method userInfo:details];
			
			return nil;
			
			break;
	}
	
	return requestUrl;
}

@end
