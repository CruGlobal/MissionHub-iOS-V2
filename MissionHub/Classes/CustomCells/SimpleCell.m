//
//  SimpleCell.m
//  MissionHub
//
//  Created by David Ang on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimpleCell.h"

#define SIMPLE_CELL_FONT_SIZE 14.0f
#define SIMPLE_CELL_WIDTH 320.0f
#define SIMPLE_CELL_DEFAULT_HEIGHT 44.0f
#define SIMPLE_CELL_DEFAULT_MAX_HEIGHT 20000.0f
#define SIMPLE_CELL_CONTENT_WIDTH 287.0f
#define SIMPLE_CELL_CONTENT_HEIGHT 21.0f
#define SIMPLE_CELL_CONTENT_MARGIN_TOP 10.0f
#define SIMPLE_CELL_CONTENT_MARGIN_LEFT 13.0f
#define SIMPLE_CELL_CONTENT_MARGIN_RIGHT 20.0f
#define SIMPLE_CELL_CONTENT_MARGIN_BOTTOM 3.0f


@implementation SimpleCell

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

+(CGFloat)cellHeightFromValueText:(NSString *)comment {
	
	if (comment == nil) {
		comment = @"";
	}
	
	if ([comment length] == 0) {
		return SIMPLE_CELL_DEFAULT_HEIGHT;
	}
	
	CGSize constraint = CGSizeMake(SIMPLE_CELL_WIDTH - SIMPLE_CELL_CONTENT_MARGIN_LEFT - SIMPLE_CELL_CONTENT_MARGIN_RIGHT, SIMPLE_CELL_DEFAULT_MAX_HEIGHT);
	
	CGSize size = [comment sizeWithFont:[UIFont systemFontOfSize:SIMPLE_CELL_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	
	CGFloat height = MAX(size.height, SIMPLE_CELL_DEFAULT_HEIGHT);
	
	return height + SIMPLE_CELL_CONTENT_MARGIN_TOP + SIMPLE_CELL_CONTENT_MARGIN_BOTTOM;
	
}

+(CGRect)labelFrameFromValueText:(NSString *)comment {
	
	if (comment == nil) {
		comment = @"";
	}
	
	if ([comment length] == 0) {
		return CGRectMake(SIMPLE_CELL_CONTENT_MARGIN_LEFT, SIMPLE_CELL_CONTENT_MARGIN_TOP, SIMPLE_CELL_CONTENT_WIDTH, SIMPLE_CELL_CONTENT_HEIGHT);
	}
	
	CGSize constraint = CGSizeMake(SIMPLE_CELL_WIDTH - SIMPLE_CELL_CONTENT_MARGIN_LEFT - SIMPLE_CELL_CONTENT_MARGIN_RIGHT, SIMPLE_CELL_DEFAULT_MAX_HEIGHT);
	
	CGSize size = [comment sizeWithFont:[UIFont systemFontOfSize:SIMPLE_CELL_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	
	return CGRectMake(SIMPLE_CELL_CONTENT_MARGIN_LEFT, SIMPLE_CELL_CONTENT_MARGIN_TOP, SIMPLE_CELL_CONTENT_WIDTH, MAX(size.height, SIMPLE_CELL_DEFAULT_HEIGHT));
	
}

- (void)setData:(NSDictionary *)data {
    UILabel *label;

    label = (UILabel *)[self viewWithTag:1];
    label.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"label"]];

    label = (UILabel *)[self viewWithTag:2];
    label.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"value"]];
	
	[label setFrame:[SimpleCell labelFrameFromValueText:label.text]];
	
}

@end
