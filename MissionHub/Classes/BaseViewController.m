//
//  BaseViewController.m
//  MissionHub
//
//  Created by David Ang on 12/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "TipViewController.h"
#import "NoInternetViewController.h"

#import "Reachability.h"

@implementation BaseViewController

@synthesize activityView;
@synthesize activityLabel;
@synthesize alreadyShowNoInternet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *childClassName = NSStringFromClass([self class]);
    NSMutableString *nibName = [NSMutableString stringWithString:childClassName];
    if ([UIDevice instancesRespondToSelector:@selector(userInterfaceIdiom)]) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [nibName appendString:@"_iPad"];
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    // Determine the class name of this view controller using reflection.
    NSString *className = NSStringFromClass([self class]);
    [[EasyTracker sharedTracker] dispatchViewDidAppear:className];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults stringForKey:@"showGuides"] || ![userDefaults stringForKey:[NSString stringWithFormat:@"tip-%@", className]]) {        
        [userDefaults setObject:@"1" forKey:[NSString stringWithFormat:@"tip-%@", className]];
        
        // Load the tips into an NSDictionary
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"tips.plist"];
        NSDictionary *tips = [NSDictionary dictionaryWithContentsOfFile:finalPath];        
        NSString *tipText = [tips objectForKey:className];
        if(tipText) {
            TipViewController *tipViewController = [[TipViewController alloc] initWithNibName:@"TipViewController" bundle:nil];
            [self presentPopupViewController:tipViewController animationType:MJPopupViewAnimationFade];
            
            [tipViewController.textView setText:tipText];
        }
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initActivityLabel];
    alreadyShowNoInternet = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reachabilityChanged:) 
                                                 name:kReachabilityChangedNotification 
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.missionhub.com"];
    
    reach.reachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Can be reach");
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Cannot be reach");
            // ensure that this is only displayed once
            if (!alreadyShowNoInternet) {
                alreadyShowNoInternet = YES;
                NoInternetViewController *noInternetViewController = [[NoInternetViewController alloc] initWithNibName:@"NoInternetViewController" bundle:nil];
                [self presentPopupViewController:noInternetViewController animationType:MJPopupViewAnimationFade];
            }
        });
    };
    
    [reach startNotifier];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) makeAPIv3Request:(NSString *)path params:(NSString*)aParams identifier:(NSString*)aIdentifier {
    NSString *baseUrl = @"https://www.missionhub.com/apis/v3";
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?%@&organization_id=%@&access_token=%@", baseUrl, path, aParams, CurrentUser.orgId, CurrentUser.accessToken];
    NSLog(@"making API v3 http GET request: %@", requestUrl);
	
    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.userInfo = aIdentifier;
    request.cachePolicy = TTURLRequestCachePolicyNone;
    request.response = [[TTURLJSONResponse alloc] init];
    [request send];
}

- (void) makeAPIv3Request:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostData {
	/*
    NSString *baseUrl = @"https://www.missionhub.com/apis/v3";
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?organization_id=%@&access_token=%@&", baseUrl, path, CurrentUser.orgId, CurrentUser.accessToken];
    
	NSMutableString* postStr = [NSMutableString string];
    for (NSString *key in aPostData) {
        NSString *value = [aPostData objectForKey: key];
        [postStr appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
    }
	
	//remove last &
	if ( [postStr length] > 0) {
		[postStr deleteCharactersInRange:NSMakeRange([postStr length]-1, 1)];
	}
	
	requestUrl = [requestUrl stringByAppendingString:postStr];
	
	NSLog(@"making http POST request: %@", requestUrl);
	
    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.userInfo = aIdentifier;
    request.response = [[TTURLJSONResponse alloc] init];
    request.httpMethod = @"POST";
    request.cachePolicy = TTURLRequestCachePolicyNone;
    request.contentType = @"application/json";
	*/
	
	NSString *baseUrl = @"https://www.missionhub.com/apis/v3";
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?organization_id=%@&access_token=%@", baseUrl, path, CurrentUser.orgId, CurrentUser.accessToken];
	
	NSLog(@"making http POST request: %@", requestUrl);
	
	TTURLRequest* request = [TTURLRequest requestWithURL: requestUrl delegate: self];
	request.httpMethod = @"POST";
	request.cachePolicy = TTURLRequestCachePolicyNoCache;
	request.response = [[TTURLJSONResponse alloc] init];
	
	SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
	NSString* json = [jsonWriter stringWithObject:aPostData];
	NSData *jsonData = [NSData dataWithBytes:[json UTF8String] length:[json length]];
	[request setHttpBody:jsonData];
	
	NSLog(@"   post params: %@", json);
	
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
	
	[request send];
	
	/*
    NSMutableString* postStr = [NSMutableString stringWithString:@"{"];
    for (NSString *key in aPostData) {
        
		NSString *value = [aPostData objectForKey: key];
        
		[postStr appendString:[NSString stringWithFormat:@"\"%@\":", key]];
		
		if ([value isKindOfClass:[NSNumber class]]) {
		
			[postStr appendString:[NSString stringWithFormat:@"%@,", value]];
		
		} else {
			
			[postStr appendString:[NSString stringWithFormat:@"\"%@\",", value]];
			
		}
		
        [request.parameters setObject:value forKey:key];
    }
	
	//remove last ,
	if ( [postStr length] > 0) {
		[postStr deleteCharactersInRange:NSMakeRange([postStr length]-1, 1)];
	}
	
	[postStr appendString:@"}"];
	
	
    NSLog(@"   post params: %@", postStr);
    NSData *postData = [ NSData dataWithBytes: [ postStr UTF8String ] length: [ postStr length ] ];
    request.httpBody = postData;
	*/
	
    [request send];
}

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier {
    [self makeHttpRequest:path params:@"" identifier:aIdentifier];
}

- (void) makeHttpRequest:(NSString *)path params:(NSString*)aParams identifier:(NSString*)aIdentifier {
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?%@&org_id=%@&access_token=%@", baseUrl, path, aParams, CurrentUser.orgId, CurrentUser.accessToken];
    NSLog(@"making http GET request: %@", requestUrl);

    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.userInfo = aIdentifier;
    request.cachePolicy = TTURLRequestCachePolicyNone;
    request.response = [[TTURLJSONResponse alloc] init];
    [request send];
}

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostData {
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?org_id=%@&access_token=%@", baseUrl, path, CurrentUser.orgId, CurrentUser.accessToken];
    NSLog(@"making http POST request: %@", requestUrl);

    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.userInfo = aIdentifier;
    request.response = [[TTURLJSONResponse alloc] init];
    request.httpMethod = @"POST";
    request.cachePolicy = TTURLRequestCachePolicyNone;
    request.contentType = @"application/x-www-form-urlencoded";

    NSMutableString* postStr = [NSMutableString string];
    for (NSString *key in aPostData) {
        NSString *value = [aPostData objectForKey: key];
        [postStr appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];

        [request.parameters setObject:value forKey:key];
    }
	
    NSLog(@"   post params: %@", postStr);
    NSData *postData = [ NSData dataWithBytes: [ postStr UTF8String ] length: [ postStr length ] ];
    request.httpBody = postData;

    [request send];
}

- (void)requestDidStartLoad:(TTURLRequest*)request {
     NSLog(@"start live http request: %@ method: %@", request.urlPath, request.httpMethod);
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {

    TTURLJSONResponse* response = request.response;
    if (request.respondedFromCache) {
        NSLog(@"requestDidFinishLoad from cache:%@", response.rootObject);
    } else {
        NSLog(@"requestDidFinishLoad:%@", response.rootObject);
    }

    [self handleRequestResult:response.rootObject identifier:request.userInfo];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {

    int status = [error code];
    NSLog(@"request error on identifier: %@. HTTP return status code: %d", request.userInfo, status);
    //NSLog(@"request didFailLoadWithError:%@", [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]);
}

// Empty implementation, child class can override behavior to handle result from the HTTP request
- (void) handleRequestResult:(NSDictionary *)aResult identifier:(NSString*)aIdentifier {
}

- (void) initActivityLabel {
    activityView = [[UIView alloc] initWithFrame:self.view.frame];
    [activityView setBackgroundColor:[UIColor blackColor]];
    activityView.alpha = 0.5f;
    activityLabel = [[TTActivityLabel alloc] initWithStyle:TTActivityLabelStyleBlackBezel];
    activityLabel.alpha = 1.f;
    [activityLabel setFrame: CGRectMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2, activityLabel.bounds.size.width, activityLabel.bounds.size.height)];
    [self.view addSubview:activityView];
    [self.view addSubview:activityLabel];

    [self hideActivityLabel];
}

- (void) showActivityLabel {
    [activityLabel setText: @" Loading..."];

    [self.view bringSubviewToFront:activityView];
    [self.view bringSubviewToFront:activityLabel];
    [activityView setHidden:NO];
    [activityLabel setHidden:NO];
}

- (void) showActivityLabel:(BOOL)aDimBackground {
    [activityLabel setText: @" Loading..."];

    if (aDimBackground) {
        [self showActivityLabel];
    } else {
        [self.view bringSubviewToFront:activityLabel];
        [activityLabel setHidden:NO];
    }
}

- (void) showActivityLabelWithText:(NSString*)aText dimBackground:(BOOL)aDimBackground {
    [activityLabel setText:aText];

    if (aDimBackground) {
        [self.view bringSubviewToFront:activityLabel];
        [activityView setHidden:NO];
    }
    [self.view bringSubviewToFront:activityLabel];
    [activityLabel setHidden:NO];

}

- (void) hideActivityLabel {
    [activityView setHidden:YES];
    [activityLabel setHidden:YES];

}

- (void)resizeFontForLabel:(UILabel*)aLabel maxSize:(int)maxSize minSize:(int)minSize {
    // use font from provided label so we don't lose color, style, etc
    UIFont *font = aLabel.font;

    // start with maxSize and keep reducing until it doesn't clip
    for(int i = maxSize; i >= minSize; i--) {
        font = [font fontWithSize:i];
        CGSize constraintSize = CGSizeMake(aLabel.frame.size.width, MAXFLOAT);

        // This step checks how tall the label would be with the desired font.
        CGSize labelSize = [aLabel.text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        if(labelSize.height <= aLabel.frame.size.height)
            break;
    }
    // Set the UILabel's font to the newly adjusted font.
    aLabel.font = font;
}

- (void)cancelButtonClicked:(TipViewController *)tipsViewController {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    tipsViewController = nil;
}


-(void)reachabilityChanged:(NSNotification*)note {
    Reachability * reach = [note object];
    
    if([reach isReachable]) {
        NSLog(@"Notification can be reach");
    }
    else {
        NSLog(@"Notification cannot be reach");
        if (!alreadyShowNoInternet) {
            alreadyShowNoInternet = YES;
//            NoInternetViewController *noInternetViewController = [[NoInternetViewController alloc] initWithNibName:@"NoInternetViewController" bundle:nil];
//            [self presentPopupViewController:noInternetViewController animationType:MJPopupViewAnimationFade];
        }
    }
}



@end
