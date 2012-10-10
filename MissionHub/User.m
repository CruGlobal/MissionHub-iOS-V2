//
//  User.m
//  MissionHub
//
//  Created by David Ang on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "MissionHubAppDelegate.h"

static User *sharedUser = nil;

@implementation User

@synthesize name;
@synthesize userId;
@synthesize orgId;
@synthesize fbId;
@synthesize data;
@synthesize accessToken;
@synthesize organizations;
@synthesize picture;

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
    
   // pluck some values for short cut 
   self.name = [data objectForKey:@"name"];
   self.fbId = [data objectForKey:@"fb_id"];
   self.organizations = [data objectForKey:@"organization_membership"];
   self.userId = [[data objectForKey:@"id"] stringValue];
    self.picture = [data objectForKey:@"picture"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *savedOrgId = [userDefaults stringForKey:@"orgId"];
    if (savedOrgId) {
        self.orgId = savedOrgId; 
    } else {
        self.orgId = [[data objectForKey:@"request_org_id"] stringValue];        
    }
    
   NSLog(@"Current user name is: %@", self.name);
   NSLog(@"Organization: %@", self.organizations); 
}

- (void) logout {
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"base_url"];    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/auth/facebook/logout", baseUrl];

    NSLog(@"request:%@", requestUrl);    
    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    //request.response = [[[TTURLDataResponse alloc] init] autorelease];
    [request send];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    //TTURLDataResponse *response =  (TTURLDataResponse *)request.response; 
    //NSLog(@"requestDidFinishLoad:%@", [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]);
    
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];

    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://login"]];    
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
