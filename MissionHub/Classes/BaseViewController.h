//
//  BaseViewController.h
//  MissionHub
//
//  Created by David Ang on 12/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionHubAppDelegate.h"

@interface BaseViewController : UIViewController<TTURLRequestDelegate>


- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier;
- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostData;

// Override these methods on child classes for specifics
- (void) handleRequestResult:(id *)aResult identifier:(NSString*)aIdentifier;


@end
