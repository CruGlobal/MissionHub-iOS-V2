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

@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *gender;
@property(nonatomic, strong) NSString *address1;
@property(nonatomic, strong) NSString *address2;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *zip;



-(void) create:(void(^)(int))handler;

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostDat;

@end
