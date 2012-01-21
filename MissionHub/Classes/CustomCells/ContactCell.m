//
//  ContactCell.m
//  MissionHub
//
//  Created by David Ang on 12/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactCell.h"
#import "MissionHubAppDelegate.h"
#import "HJManagedImageV.h"

@implementation ContactCell

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
    UILabel *label;
    UIImageView *placeHolderImageView = (UIImageView *)[self viewWithTag:1];

    label = (UILabel *)[self viewWithTag:2];
    label.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"name"]];

    NSString *fbUrl = [data objectForKey:@"picture"];
    NSURL * imageURL = [NSURL URLWithString: fbUrl];


    HJManagedImageV* mi = nil;
    if ([self viewWithTag:999] == nil) {
       NSLog(@"loading image for %@ with url: %@", label.text, [imageURL absoluteString]);
       mi = [[[HJManagedImageV alloc] initWithFrame:placeHolderImageView.frame] autorelease];;
       mi.tag = 999;
       [self addSubview: mi];
    } else {
       mi = (HJManagedImageV*) [self viewWithTag:999];
       [mi clear];
    }

    if ([fbUrl length] != 0) {
        mi.url = imageURL;
        [AppDelegate.imageManager manage:mi];
    }

}


@end
