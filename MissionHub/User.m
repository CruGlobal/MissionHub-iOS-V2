//
//  User.m
//  MissionHub
//
//  Created by David Ang on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"

static User *sharedUser = nil;

@implementation User

@synthesize name;
@synthesize fbId;
@synthesize data;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark -
#pragma mark Singleton Methods
+ (User *)sharedUser {
    if(sharedUser == nil){
        sharedUser = [[[self alloc] init] autorelease];
        NSLog(@"shared user object allocated");
        //sharedUser = [[super allocWithZone:NULL] init];
    }
    return sharedUser;
}

- (void) setData:(NSDictionary*)input {
    [data autorelease];
    data = [input retain];
    
   self.name = [data objectForKey:@"name"];
    
    NSLog(@"Current user name is: %@", self.name);
}

//+ (id)allocWithZone:(NSZone *)zone {
//    return [[self sharedManager] retain];
//}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return NSUIntegerMax;
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end
