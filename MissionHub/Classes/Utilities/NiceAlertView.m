//
//  NiceAlertView.m
//  MissionHub
//
//  Created by David Ang on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NiceAlertView.h"

static NiceAlertView *sharedNiceAlertView = nil;

@implementation NiceAlertView

@synthesize styledLabel;

- (id)init
{
    self = [super init];
    if (self) {
        UIFont *aFont = [UIFont systemFontOfSize:18];
        
        // Initialization code here.
        self.style =  [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:10] next:
                       [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.5) blur:5 offset:CGSizeMake(1, 1) next:
                        [TTSolidFillStyle styleWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.75] next: nil
                         ]]];
        [self setBackgroundColor:[UIColor clearColor]];
        
        styledLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
        styledLabel.font = aFont;
        styledLabel.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        styledLabel.backgroundColor = [UIColor clearColor];
        styledLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
        styledLabel.textAlignment = UITextAlignmentCenter;
    }
    
    return self;
}

+ (NiceAlertView *)sharedNiceAlertView {
    if(sharedNiceAlertView == nil){
        sharedNiceAlertView = [[self alloc] init];
        NSLog(@"shared nice alert view allocated");
        //sharedUser = [[super allocWithZone:NULL] init];
    }
    return sharedNiceAlertView;
}

- (void)showWithText:(NSString*)text {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    styledLabel.text = [TTStyledText textFromXHTML:text lineBreaks:YES URLs:NO];
    CGSize maximumLabelSize = CGSizeMake(296,9999);
    CGSize textSize = [text sizeWithFont:[styledLabel font] constrainedToSize:maximumLabelSize  lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat textWidth = textSize.width;
    CGFloat textHeight = textSize.height + 45;
    
    CGRect styledLabelFrame = CGRectMake(0, 0, textWidth, textHeight);
    [styledLabel setFrame:styledLabelFrame];
    
    styledLabelFrame.origin.x = window.bounds.size.width / 2 - textWidth / 2;
    styledLabelFrame.origin.y = 150;
    [self setFrame:styledLabelFrame];
    
    [self addSubview:styledLabel];
    [window addSubview:self];
    
    NSLog(@"subviews: %d", [self.subviews count]);
    
    self.alpha = 1.0;
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(removeAlert) userInfo:nil repeats:NO];
}

- (id)initWithText:(NSString*)text {
	return [self initWithText:text font:[UIFont systemFontOfSize:18] duration:2.0];
}

- (id)initWithText:(NSString*)text duration:(NSTimeInterval)aDuration {
    return [self initWithText:text font:[UIFont systemFontOfSize:18] duration:aDuration];
}

- (id)initWithText:(NSString*)text font:(UIFont*)aFont duration:(NSTimeInterval)aDuration {
    self = [self init];
    if (self) {

        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.style =  [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:10] next:
                       [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.5) blur:5 offset:CGSizeMake(1, 1) next:
                        [TTSolidFillStyle styleWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.75] next: nil
                         ]]];
        [self setBackgroundColor:[UIColor clearColor]];

        TTStyledTextLabel* styledLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
        styledLabel.font = aFont;
        styledLabel.text = [TTStyledText textFromXHTML:text lineBreaks:YES URLs:NO];
        styledLabel.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        styledLabel.backgroundColor = [UIColor clearColor];
        styledLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
        styledLabel.textAlignment = UITextAlignmentCenter;

        CGSize maximumLabelSize = CGSizeMake(296,9999);
        CGSize textSize = [text sizeWithFont:[styledLabel font] constrainedToSize:maximumLabelSize  lineBreakMode:UILineBreakModeWordWrap];

        CGFloat textWidth = textSize.width;
        CGFloat textHeight = textSize.height + 45;

        CGRect styledLabelFrame = CGRectMake(0, 0, textWidth, textHeight);
        [styledLabel setFrame:styledLabelFrame];

        styledLabelFrame.origin.x = window.bounds.size.width / 2 - textWidth / 2;
        styledLabelFrame.origin.y = 150;
        [self setFrame:styledLabelFrame];

        [self addSubview:styledLabel];
        [window addSubview:self];

        [NSTimer scheduledTimerWithTimeInterval:aDuration target:self selector:@selector(removeAlert) userInfo:nil repeats:NO];
    }
    return self;
}

- (void) removeAlert {
    [UIView animateWithDuration:1.25f
                     animations:^{self.alpha = 0.0;
                     }
                     completion:^(BOOL done){
                         [self removeFromSuperview];
                     }];

}

@end
