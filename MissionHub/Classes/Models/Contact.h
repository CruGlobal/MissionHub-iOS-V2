//
//  Contact.h
//  MissionHub
//
//  Created by David Ang on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject<TTURLRequestDelegate> {
    void (^_completionHandler)(int someParameter);    
}

@property(strong) NSString *firstName;
@property(strong) NSString *lastName;
@property(strong) NSString *email;
@property(strong) NSString *phone;
@property(strong) NSString *gender;
@property(strong) NSString *address1;
@property(strong) NSString *address2;
@property(strong) NSString *city;
@property(strong) NSString *zip;



-(void) create:(void(^)(int))handler;

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostDat;

@end
