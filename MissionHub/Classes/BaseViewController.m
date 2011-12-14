//
//  BaseViewController.m
//  MissionHub
//
//  Created by David Ang on 12/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
    
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@?access_token=%@", baseUrl, path, CurrentUser.accessToken];
    
    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.userInfo = aIdentifier;
    request.response = [[[TTURLJSONResponse alloc] init] autorelease];
    [request send];
}

- (void)requestDidStartLoad:(TTURLRequest*)request {    
     NSLog(@"making http request: %@", request.urlPath);    
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
    NSLog(@"Error on BaseScene::serviceResultHandler. HTTP return status code: %d", status);
    //NSLog(@"request didFailLoadWithError:%@", [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]);
}

// Empty implementation, child class can override behavior to handle result from the HTTP request
- (void) handleRequestResult:(id *)aResult identifier:(NSString*)aIdentifier {
}

@end
