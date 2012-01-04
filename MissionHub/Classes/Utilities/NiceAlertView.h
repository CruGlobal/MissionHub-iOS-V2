//
//  NiceAlertView.h
//  MissionHub
//
//  Created by David Ang on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface NiceAlertView : TTView

- (id)initWithText:(NSString*)text;

- (id)initWithText:(NSString*)text duration:(NSTimeInterval)aDuration;

- (id)initWithText:(NSString*)text font:(UIFont*)aFont duration:(NSTimeInterval)aDuration;

@end
