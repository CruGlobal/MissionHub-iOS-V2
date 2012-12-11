//
//  MHConfiguration.m
//  MissionHub
//
//  Created by Michael Harrison on 12/10/12.
//
//

#import "MHConfiguration.h"

@implementation MHConfiguration

static MHConfiguration *_sharedInstance = nil;

+(MHConfiguration *)sharedInstance {
	
	if (_sharedInstance == nil) {
		
		NSString	*path		= [[NSBundle mainBundle] bundlePath];
		NSString	*finalPath	= [path stringByAppendingPathComponent:@"config.plist"];
		MHConfiguration *config	= (MHConfiguration *)[NSDictionary dictionaryWithContentsOfFile:finalPath];
		_sharedInstance			= config;
		
	}
	
	return _sharedInstance;
	
}

@end
