//
//  TableSubtitleItemCell.m
//  MissionHub
//
//  Created by David Ang on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableSubtitleItemCell.h"
#import "Three20UI/TTTableSubtitleItemCell.h"

@implementation TableSubtitleItemCell

- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];

        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
}

//+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
//    return 59;
//}  

//
/////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.contentView.frame = CGRectMake(0, 0, 320, 59);
    
    _imageView2.frame = CGRectMake(5, 5, 50, 50); 

//    self.textLabel.frame = CGRectMake(_imageView2.frame.size.width + 10, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
//    self.detailTextLabel.frame = CGRectMake(_imageView2.frame.size.width + 10, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
}

@end
