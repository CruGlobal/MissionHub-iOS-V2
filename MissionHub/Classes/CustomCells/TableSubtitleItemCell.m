//
//  TableSubtitleItemCell.m
//  MissionHub
//
//  Created by David Ang on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableSubtitleItemCell.h"

@implementation TableSubtitleItemCell

- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];
        
//        TTTableSubtitleItem *item = object;
//        if (item.imageURL == nil) {
//            UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook_male.gif"]];
//            [placeholderImageView setFrame:self.imageView2.frame];
//            [self.contentView addSubview:placeholderImageView];
//            //[self addSubview:placeholderImageView];
//        }

        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
}
    
@end
