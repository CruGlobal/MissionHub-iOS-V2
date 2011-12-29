//
//  CreateContactViewController.h
//  MissionHub
//
//  Created by David Ang on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface CreateContactViewController : BaseViewController {
    UIView* _headerView;
    UIView* _footerView;
}

@property (nonatomic, retain) IBOutlet UIView* headerView;
@property (nonatomic, retain) IBOutlet UIView* footerView;

@end

@interface CreateContactQuickDialogDelegate : QuickDialogController 

@end