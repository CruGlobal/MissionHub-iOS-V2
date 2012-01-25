//
//  TableViewController.h
//  MissionHub
//
//  Created by David Ang on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface TableViewController : TTTableViewController

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier;
- (void) makeHttpRequest:(NSString *)path params:(NSString*)aParams identifier:(NSString*)aIdentifier;
- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostData;
- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier postString:(NSString*)aPostString;

// Override these methods on child classes for specifics
- (void) handleRequestResult:(NSDictionary *)aResult identifier:(NSString*)aIdentifier;


@end
