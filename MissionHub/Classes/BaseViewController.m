//
//  BaseViewController.m
//  MissionHub
//
//  Created by David Ang on 12/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

@synthesize activityView;
@synthesize activityLabel;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initActivityLabel];
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
    request.response = [[[TTURLJSONResponse alloc] init] autorelease];
    [request send];    
}

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostData {
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?org_id=%@&access_token=%@", baseUrl, path, CurrentUser.orgId, CurrentUser.accessToken];
    NSLog(@"making http POST request: %@", requestUrl);    
    
    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.userInfo = aIdentifier;
    request.response = [[[TTURLJSONResponse alloc] init] autorelease];
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
    
    [self handleRequestResult:(id*)response.rootObject identifier:request.userInfo];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    
    int status = [error code];
    NSLog(@"request error on identifier: %@. HTTP return status code: %d", request.userInfo, status);
    //NSLog(@"request didFailLoadWithError:%@", [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]);
}

// Empty implementation, child class can override behavior to handle result from the HTTP request
- (void) handleRequestResult:(id *)aResult identifier:(NSString*)aIdentifier {
}

- (void) initActivityLabel {
    activityView = [[UIView alloc] initWithFrame:self.view.frame];
    [activityView setBackgroundColor:[UIColor blackColor]];                                           
    activityView.alpha = 0.5f;
    activityLabel = [[[TTActivityLabel alloc] initWithStyle:TTActivityLabelStyleBlackBezel] autorelease];
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

@end
