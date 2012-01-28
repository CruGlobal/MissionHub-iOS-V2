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

- (void) makeHttpPostRequest:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostData;
- (void) makeHttpPostRequest:(NSString *)path identifier:(NSString*)aIdentifier postString:(NSString*)aPostString;
- (void) makeHttpPutRequest:(NSString *)path identifier:(NSString*)aIdentifier params:(NSString*)aParams;

// Override these methods on child classes for specifics
- (void) handleRequestResult:(NSDictionary *)aResult identifier:(NSString*)aIdentifier;


@end
