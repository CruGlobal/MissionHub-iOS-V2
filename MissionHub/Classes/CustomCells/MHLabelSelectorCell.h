//
//  MHLabelSelectorCell.h
//  MissionHub
//
//  Created by Michael Harrison on 2/19/13.
//
//

#import <UIKit/UIKit.h>

@class MHLabelSelectorCell;
@class MHRole;

@protocol MHLabelSelectorCellDelegate  <NSObject>

- (void)roleTableViewCell:(MHLabelSelectorCell *)cell didTapIconWithRoleItem:(id)roleItem;

@end

@interface MHLabelSelectorCell : UITableViewCell

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, assign) id <MHLabelSelectorCellDelegate> delegate;
@property (nonatomic, strong) id role;

- (void)setChecked:(BOOL)checked;
- (void)iconButtonAction:(id)sender;

@end