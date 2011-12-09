//
//  User.h
//  MissionHub
//
//  Created by David Ang on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject {
    NSString *accessToken;
    
    NSString *name;
    NSString *fbId;
    
    NSDictionary *data;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *fbId;
@property (nonatomic, retain) NSDictionary *data;

- (void) setData:(NSDictionary*)input;

+ (User *)sharedUser;

@end
