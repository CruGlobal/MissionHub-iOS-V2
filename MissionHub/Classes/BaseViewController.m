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
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?%@&access_token=%@", baseUrl, path, aParams, CurrentUser.accessToken];
    NSLog(@"making http GET request: %@", requestUrl);    
    
    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.userInfo = aIdentifier;
    request.cachePolicy = TTURLRequestCachePolicyNone;
    request.response = [[[TTURLJSONResponse alloc] init] autorelease];
    [request send];    

    [self showActivityLabel];
}

- (void) makeHttpRequest:(NSString *)path identifier:(NSString*)aIdentifier postData:(NSDictionary*)aPostData {
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?access_token=%@", baseUrl, path, CurrentUser.accessToken];
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
    
    [self showActivityLabel];
}

- (void)requestDidStartLoad:(TTURLRequest*)request {    
     NSLog(@"start live http request: %@ method: %@", request.urlPath, request.httpMethod);    
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    [self hideActivityLabel];
    
    TTURLJSONResponse* response = request.response;
    if (request.respondedFromCache) {
        NSLog(@"requestDidFinishLoad from cache:%@", response.rootObject);   
    } else {
        NSLog(@"requestDidFinishLoad:%@", response.rootObject);   
    }
    
    [self handleRequestResult:(id*)response.rootObject identifier:request.userInfo];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    [self hideActivityLabel];
    
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
    [activityLabel setText: @" Loading..."];
    [activityLabel setFrame: CGRectMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2, activityLabel.bounds.size.width, activityLabel.bounds.size.height)];
    [self.view addSubview:activityView];
    [self.view addSubview:activityLabel];        
    
    [self hideActivityLabel];
}

- (void) showActivityLabel {
    [activityView setHidden:NO];
    [activityLabel setHidden:NO];    
}

- (void) hideActivityLabel {
    [activityView setHidden:YES];
    [activityLabel setHidden:YES];    
    
}

@end
