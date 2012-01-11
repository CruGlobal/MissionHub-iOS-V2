//
//  ProfileViewController.h
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface ProfileViewController : BaseViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, retain) NSMutableArray *orgsArray;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *orgLabel;
@property (nonatomic, retain) IBOutlet UIImageView *placeHolderImageView;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;

- (IBAction)onLogoutBtn:(id)sender;
- (IBAction)onBackBtn:(id)sender;
- (IBAction)onChangeOrgBtn:(id)sender;


@end
