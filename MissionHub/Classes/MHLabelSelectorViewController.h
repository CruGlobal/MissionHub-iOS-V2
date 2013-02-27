//
//  MHLabelSelectorViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 2/19/13.
//
//

#import <UIKit/UIKit.h>
#import "MHLabelSelectorCell.h"
#import "MHRolesCollection.h"

@protocol MHLabelSelectorDelegate  <NSObject>

- (void)addLabels:(NSArray *)addLabels removeLabels:(NSArray *)removeLabels;

@end

@interface MHLabelSelectorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MHLabelSelectorCellDelegate>

@property (nonatomic, retain) id<MHLabelSelectorDelegate>	delegate;
@property (nonatomic, retain) MHRolesCollection				*allRoles, *selectedRoles, *originallySelectedRoles;
@property (nonatomic, retain) IBOutlet UIBarButtonItem		*applyButton;
@property (nonatomic, retain) IBOutlet UITableView			*tableView;

-(void)updateRoles:(MHRolesCollection *)roles;
-(void)updateSelectedRoles:(MHRolesCollection *)selected;

-(IBAction)onApply:(id)sender;

@end
