//
//  BaseViewController.h
//  MissionHub
//
//  Created by David Ang on 12/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionHubAppDelegate.h"

@interface BaseViewController : UIViewController <TTURLRequestDelegate>

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier;
- (void) makeHttpRequest:(NSString *)path params:(NSString*)aParams identifier:(NSString*)aIdentifier;
- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostData;
- (void) makeAPIv3Request:(NSString *)path params:(NSString*)aParams identifier:(NSString*)aIdentifier;
- (void) makeAPIv3Request:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostData;

// Override these methods on child classes for specifics
- (void) handleRequestResult:(NSDictionary *)aResult identifier:(NSString*)aIdentifier;

- (void) initActivityLabel;
- (void) showActivityLabel;
- (void) showActivityLabel:(BOOL)aDimBackground;
- (void) showActivityLabelWithText:(NSString*)aText dimBackground:(BOOL)aDimBackground;
- (void) hideActivityLabel;
- (void) resizeFontForLabel:(UILabel*)aLabel maxSize:(int)maxSize minSize:(int)minSize;
- (void) reachabilityChanged:(NSNotification*)note;

@property (nonatomic, retain) TTActivityLabel *activityView;
@property (nonatomic, retain) TTActivityLabel *activityLabel;
@property (nonatomic, assign) BOOL alreadyShowNoInternet;


@end
