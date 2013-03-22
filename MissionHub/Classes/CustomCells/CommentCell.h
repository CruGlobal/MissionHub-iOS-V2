//
//  CommentCell.h
//  MissionHub
//
//  Created by David Ang on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

- (void)setData:(NSDictionary *)data;

+(CGFloat)cellHeightFromCommentText:(NSString *)comment;
+(CGRect)labelFrameFromCommentText:(NSString *)comment;

@end
