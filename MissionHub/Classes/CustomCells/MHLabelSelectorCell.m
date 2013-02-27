//
//  LabelSelectorCell.m
//  MissionHub
//
//  Created by Michael Harrison on 2/19/13.
//
//

#import "MHLabelSelectorCell.h"
#import <QuartzCore/QuartzCore.h>

#define KOCOLOR_FILES_TITLE [UIColor colorWithRed:0.4 green:0.357 blue:0.325 alpha:1] /*#665b53*/
#define KOCOLOR_FILES_TITLE_SHADOW [UIColor colorWithRed:1 green:1 blue:1 alpha:1] /*#ffffff*/
#define KOCOLOR_FILES_COUNTER [UIColor colorWithRed:0.608 green:0.376 blue:0.251 alpha:1] /*#9b6040*/
#define KOCOLOR_FILES_COUNTER_SHADOW [UIColor colorWithRed:1 green:1 blue:1 alpha:0.35] /*#ffffff*/
#define KOFONT_FILES_TITLE [UIFont fontWithName:@"HelveticaNeue" size:18.0f]
#define KOFONT_FILES_COUNTER [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]

@implementation MHLabelSelectorCell

@synthesize backgroundImageView;
@synthesize iconButton;
@synthesize titleTextField;
@synthesize delegate;
@synthesize role;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
	if (self) {
        // Initialization code
		
		//backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"copymove-cell-bg"]];
		//[backgroundImageView setContentMode:UIViewContentModeTopRight];
		
		[self setBackgroundView:backgroundImageView];
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[iconButton setFrame:CGRectMake(15, 15, 14, 14)];
		[iconButton setAdjustsImageWhenHighlighted:NO];
		[iconButton addTarget:self action:@selector(iconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
		[iconButton setImage:[UIImage imageNamed:@"uncheckbox_14px"] forState:UIControlStateNormal];
		[iconButton setImage:[UIImage imageNamed:@"checkbox_14px"] forState:UIControlStateSelected];
		[iconButton setImage:[UIImage imageNamed:@"checkbox_14px"] forState:UIControlStateHighlighted];
		
		[self.contentView addSubview:iconButton];
		
		titleTextField = [[UITextField alloc] init];
		[titleTextField setFont:KOFONT_FILES_TITLE];
		[titleTextField setTextColor:KOCOLOR_FILES_TITLE];
		[titleTextField.layer setShadowColor:KOCOLOR_FILES_TITLE_SHADOW.CGColor];
		[titleTextField.layer setShadowOffset:CGSizeMake(0, 1)];
		[titleTextField.layer setShadowOpacity:1.0f];
		[titleTextField.layer setShadowRadius:0.0f];
		
		[titleTextField setUserInteractionEnabled:NO];
		[titleTextField setBackgroundColor:[UIColor clearColor]];
		[titleTextField sizeToFit];
		[titleTextField setFrame:CGRectMake(44, 10, 261, 24)];
		[self.contentView addSubview:titleTextField];
		
		[self.layer setMasksToBounds:YES];
		
    }
	
    return self;
	
}

- (void)setChecked:(BOOL)checked {
	
	[self.iconButton setSelected:checked];
	
	/*
	if (checked) {
		
		[iconButton setImage:[UIImage imageNamed:@"checkbox_14px"] forState:UIControlStateNormal];
		
	} else {
		
		[iconButton setImage:[UIImage imageNamed:@"uncheckbox_14px"] forState:UIControlStateNormal];
		
	}
	*/
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	//[self.iconButton setSelected:selected];
}

- (void)iconButtonAction:(id)sender {
	
	if (delegate && [delegate respondsToSelector:@selector(roleTableViewCell:didTapIconWithRoleItem:)]) {
		[delegate roleTableViewCell:(MHLabelSelectorCell *)self didTapIconWithRoleItem:self.role];
	}
}

@end
