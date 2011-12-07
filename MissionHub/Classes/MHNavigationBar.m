//
//  MHNavigationBar.m
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MHNavigationBar.h"

@implementation MHNavigationBar

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIImage *barImage = [UIImage imageNamed:@"MH_Nav_Bar.png"];
    [barImage drawInRect:rect];
}

@end
