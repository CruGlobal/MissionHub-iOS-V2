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
    NSDictionary *comment = [data objectForKey:@"comment"];
    NSDictionary *commenter = [comment objectForKey:@"commenter"];    
    NSDictionary *rejoicables = [data objectForKey:@"rejoicables"];     

    UILabel *label;
    
    label = (UILabel *)[self viewWithTag:2];
    label.text = [NSString stringWithFormat:@"%@", [commenter objectForKey:@"name"]];    
    
    label = (UILabel *)[self viewWithTag:3];
    label.text = [NSString stringWithFormat:@"%@", [comment objectForKey:@"comment"]];
    
    label = (UILabel *)[self viewWithTag:4];
    label.text = [NSString stringWithFormat:@"%@", [comment objectForKey:@"created_at_words"]];
    
    label = (UILabel *)[self viewWithTag:5];
    label.text = [NSString stringWithFormat:@"%@", [comment objectForKey:@"status"]];
    
    for (NSDictionary *rejoicable in rejoicables) {
        if ([[rejoicable objectForKey:@"what"] isEqualToString:@"gospel_presentation"]) {
            [(UIImageView *)[self viewWithTag:8] setHidden:NO];             
        }
        if ([[rejoicable objectForKey:@"what"] isEqualToString:@"prayed_to_receive"]) {
            [(UIImageView *)[self viewWithTag:7] setHidden:NO];             
        }
        if ([[rejoicable objectForKey:@"what"] isEqualToString:@"spiritual_conversation"]) {
            [(UIImageView *)[self viewWithTag:6] setHidden:NO]; 
            
        }
    }
}

@end
