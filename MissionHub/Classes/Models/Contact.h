//
//  Contact.h
//  MissionHub
//
//  Created by David Ang on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject<TTURLRequestDelegate>

@property(strong) NSString *firstName;
@property(strong) NSString *lastName;

-(void) create;

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostDat;

@end
