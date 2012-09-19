//
//  TipViewController.m
//  MissionHub
//
//  Created by David Ang on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TipViewController.h"
#import "UIViewController+MJPopupViewController.h"

@implementation TipViewController

@synthesize textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *childClassName = NSStringFromClass([self class]);
    NSMutableString *nibName = [NSMutableString stringWithString:childClassName];
    if ([UIDevice instancesRespondToSelector:@selector(userInterfaceIdiom)]) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [nibName appendString:@"_ipad"];
        }
    }
    
    NSLog(@"initWithNibName: %@", childClassName);
    if([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"] != nil) {
        self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    } else {
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    SSCheckBoxView *cbv = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(20, 300, 200, 30)
//                                                          style:kSSCheckBoxViewStyleGlossy
//                                                        checked:YES];
//    [cbv setText:@"Show tips again?"];
//    [self.view addSubview:cbv];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)onCloseBtn:(id)sender {
    
    NSLog(@"closePopup");
    //[self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
//        [self.delegate cancelButtonClicked:self];
//    }
}




@end
