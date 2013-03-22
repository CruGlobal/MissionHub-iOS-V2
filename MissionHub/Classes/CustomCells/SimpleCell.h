//
//  SimpleCell.h
//  MissionHub
//
//  Created by David Ang on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleCell : UITableViewCell

- (void)setData:(NSDictionary *)data;

+(CGFloat)cellHeightFromValueText:(NSString *)value;
+(CGRect)labelFrameFromValueText:(NSString *)value;

@end
