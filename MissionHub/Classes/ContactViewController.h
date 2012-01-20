//
//  ContactViewController.h
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class CommentCell;
@class SimpleCell;

@interface ContactViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) NSDictionary *personData;
@property (nonatomic, retain) NSMutableArray *commentsArray;
@property (nonatomic, retain) NSMutableArray *infoArray;
@property (nonatomic, retain) NSMutableArray *surveyArray;
@property (nonatomic, retain) NSMutableArray *rejoicablesArray;
@property (nonatomic, retain) NSString *statusSelected;
@property (nonatomic, retain) UIImagePickerController *imagePicker;

@property (nonatomic, retain) IBOutlet UILabel *nameLbl;
@property (nonatomic, retain) IBOutlet UIButton *placeHolderImageView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) IBOutlet SimpleCell *simpleCell;
@property (nonatomic, assign) IBOutlet CommentCell *commentCell;
@property (nonatomic, assign) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, assign) IBOutlet UITextView *commentTextView;
@property (nonatomic, assign) IBOutlet UIView *rejoicablesView;

//@property (nonatomic, retain) IBOutlet UIButton *callBtn;
//@property (nonatomic, retain) IBOutlet UIButton *smsBtn;
//@property (nonatomic, retain) IBOutlet UIButton *emailBtn;
@property (nonatomic, retain) IBOutlet UIButton *assignBtn;
//@property (nonatomic, retain) IBOutlet UIButton *rejoicableBtn;
@property (nonatomic, retain) IBOutlet UIButton *statusBtn;
//@property (nonatomic, retain) IBOutlet UIButton *saveBtn;
//@property (nonatomic, retain) IBOutlet UITextField *commentTxt;

- (IBAction)onBackBtn:(id)sender;

- (IBAction)onCallBtn:(id)sender;
- (IBAction)onSmsBtn:(id)sender;
- (IBAction)onEmailBtn:(id)sender;
- (IBAction)onAssignBtn:(id)sender;
- (IBAction)onShowRejoicablesBtn:(id)sender;
- (IBAction)onStatusBtn:(id)sender;
- (IBAction)onSaveBtn:(id)sender;
- (IBAction)onSegmentChange:(id)sender;
- (IBAction)onRejoicableBtn:(id)sender;
- (IBAction)onPlaceHolderImageBtn:(id)sender;

@end
