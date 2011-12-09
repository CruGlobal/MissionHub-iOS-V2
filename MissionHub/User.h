//
//  User.h
//  MissionHub
//
//  Created by David Ang on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CurrentUser \
[User sharedUser]


@interface User : NSObject {
    NSString *accessToken;
    
    NSString *name;
    NSString *fbId;
    
    NSDictionary *data;
    
    NSArray *organizations;
}

@property (nonatomic, retain) NSDictionary *data;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *fbId;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSArray *organizations;

- (void) setData:(NSDictionary*)input;

+ (User *)sharedUser;

@end
