//
//  TipViewController.h
//  MissionHub
//
//  Created by David Ang on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"


@interface TipViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextView *textView;

- (IBAction)onCloseBtn:(id)sender;

@end