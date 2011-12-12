//
//  CommentCell.m
//  MissionHub
//
//  Created by David Ang on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data {
    NSDictionary *commenter = [data objectForKey:@"commenter"];    

    UILabel *label;
    
    label = (UILabel *)[self viewWithTag:2];
    label.text = [NSString stringWithFormat:@"%@", [commenter objectForKey:@"name"]];    
    
    label = (UILabel *)[self viewWithTag:3];
    label.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"comment"]];
    
    label = (UILabel *)[self viewWithTag:4];
    label.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"created_at_words"]];
    
    label = (UILabel *)[self viewWithTag:5];
    label.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"status"]];
}

@end
