//
//  CommentCell.m
//  MissionHub
//
//  Created by David Ang on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommentCell.h"
#import "MissionHubAppDelegate.h"
#import "HJManagedImageV.h"

@implementation CommentCell

- (void)setData:(NSDictionary *)data {
    [((UILabel *)[self viewWithTag:2]) setText:@""];
    [((UILabel *)[self viewWithTag:3]) setText:@""];
    [((UILabel *)[self viewWithTag:4]) setText:@""];
    [((UILabel *)[self viewWithTag:5]) setText:@""]; 
    
    NSDictionary *comment = [data objectForKey:@"comment"];
    NSDictionary *commenter = [comment objectForKey:@"commenter"];
    NSDictionary *rejoicables = [data objectForKey:@"rejoicables"];

    UILabel *label;

    if ([commenter objectForKey:@"name"]) {
        label = (UILabel *)[self viewWithTag:2];
        label.text = [NSString stringWithFormat:@"%@", [commenter objectForKey:@"name"]];
    }

    label = (UILabel *)[self viewWithTag:3];
    label.text = [NSString stringWithFormat:@"%@", [comment objectForKey:@"comment"]];

    if ([comment objectForKey:@"created_at_words"]) {    
        label = (UILabel *)[self viewWithTag:4];
        label.text = [NSString stringWithFormat:@"%@", [comment objectForKey:@"created_at_words"]];
    }

    if ([comment objectForKey:@"status"]) {
        label = (UILabel *)[self viewWithTag:5];
        label.text = [NSString stringWithFormat:@"%@", [comment objectForKey:@"status"]];
    
        CGRect frame = label.frame;    
        
        if ([label.text isEqualToString:@"attempted_contact"]) {
            label.text = @"attempted contact";
            frame.origin.x = 200;
            frame.size.width = 100;
        } else if ([label.text isEqualToString:@"do_not_contact"]) {
            label.text = @"do not contact";
            frame.origin.x = 220;
            frame.size.width = 100;
        } else {
            frame.origin.x = 240;
            frame.size.width = 60;
        }
        
        [label setFrame:frame];        
    }

    [(UIImageView *)[self viewWithTag:6] setHidden:YES];
    [(UIImageView *)[self viewWithTag:7] setHidden:YES];
    [(UIImageView *)[self viewWithTag:8] setHidden:YES];

    // rejoicables
    for (NSDictionary *rejoicable in rejoicables) {
        if ([[rejoicable objectForKey:@"what"] isEqualToString:@"gospel_presentation"]) {
            [(UIImageView *)[self viewWithTag:6] setHidden:NO];
        }
        if ([[rejoicable objectForKey:@"what"] isEqualToString:@"prayed_to_receive"]) {
            [(UIImageView *)[self viewWithTag:7] setHidden:NO];
        }
        if ([[rejoicable objectForKey:@"what"] isEqualToString:@"spiritual_conversation"]) {
            [(UIImageView *)[self viewWithTag:8] setHidden:NO];

        }
    }

    // picture
    NSString *fbUrl = [commenter objectForKey:@"picture"];
    NSURL * imageURL = [NSURL URLWithString: fbUrl];
    UIImageView *placeHolderImageView = (UIImageView *)[self viewWithTag:1];

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
