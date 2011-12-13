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

    NSString *fbUrl = [NSString stringWithFormat:@"%@", [data objectForKey:@"picture"]]; 
    NSURL * imageURL = [NSURL URLWithString: fbUrl];
    
    HJManagedImageV* mi = [[[HJManagedImageV alloc] initWithFrame:placeHolderImageView.frame] autorelease];;
    [self addSubview: mi];
    mi.url = imageURL;
    
    [AppDelegate.imageManager manage:mi];
}


@end
