//
//  PopupTTWebController.m
//  MissionHub
//
//  Created by David Ang on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PopupTTWebController.h"
#import "MissionHubAppDelegate.h"

#import <extThree20JSON/extThree20JSON.h>

@implementation PopupTTWebController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");    
    NSLog(@"...%@", self.URL);    

    
    NSArray *parameters = [[self.URL query] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
    NSMutableDictionary *keyValueParm = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < [parameters count]; i=i+2) {
        [keyValueParm setObject:[parameters objectAtIndex:i+1] forKey:[parameters objectAtIndex:i]];
    }
    
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"oauth_url"];
    NSString *scope = [[AppDelegate config] objectForKey:@"oauth_scope"];
    NSString *clientSecret = [[AppDelegate config] objectForKey:@"oauth_client_secret"];    
    NSString *redirectUrl = @"https://www.missionhub.com/oauth/done.json";
    NSString *authorization = [keyValueParm objectForKey:@"authorization"];
    
    static int step = 0;
    
    if (step == 0) {
        step = 1;
        
        NSString *grantUrl = [NSString stringWithFormat:@"%@/grant.json?authorization=%@", baseUrl, authorization];

        TTURLRequest *request = [TTURLRequest requestWithURL: grantUrl delegate: self];
        request.response = [[[TTURLDataResponse alloc] init] autorelease];
        [request send];

    } else {
 
    

//    [request.parameters addObject:@"touch" forKey:@"display"];
//    [request.parameters addObject:@"true" forKey:@"simple"];
//    [request.parameters addObject:@"code" forKey:@"response_type"];
//    [request.parameters addObject:@"5" forKey:@"client_id"];
//    [request.parameters addObject:redirectUrl forKey:@"redirect_uri"];
//    [request.parameters addObject:clientSecret forKey:@"client_secret"];  
//    [request.parameters addObject:scope forKey:@"scope"];
//    [request.parameters addObject:authorization forKey:@"code"];      
    
    }
}

- (void)requestDidStartLoad:(TTURLRequest*)request {
    TTURLDataResponse *response =  (TTURLDataResponse *)request.response; 
    NSLog(@"requestDidStartLoad:%@", [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]);
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLDataResponse *response =  (TTURLDataResponse *)request.response; 
    NSLog(@"requestDidFinishLoad:%@", [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]);
    
    
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"oauth_url"];
    NSString *scope = [[AppDelegate config] objectForKey:@"oauth_scope"];
    NSString *clientSecret = [[AppDelegate config] objectForKey:@"oauth_client_secret"];    
    NSString *redirectUrl = @"https://www.missionhub.com/oauth/done.json";
    NSString *code = @"b1ba6e1d488b4ef1780ceec6d79b0c2d698ea23af44fbeaccb36aaa5b0c60c79";

    NSString *accessTokenUrl = [NSString stringWithFormat:@"%@/access_token?", baseUrl];
    NSString *myRequestString = [NSString stringWithFormat:@"grant_type=authorization_code&redirect_uri=%@&client_id=5&scope=%@&client_secret=%@&code=%@", redirectUrl, scope, clientSecret, code];
    
    NSData *myRequestData = [ NSData dataWithBytes: [ myRequestString UTF8String ] length: [ myRequestString length ] ];
    
    
    TTURLRequest *newRequest = [TTURLRequest requestWithURL: accessTokenUrl delegate: self];
    newRequest.contentType=@"application/x-www-form-urlencoded";    
    
    NSLog(@"request url:%@", request.urlPath);    
    newRequest.response = [[[TTURLDataResponse alloc] init] autorelease];
    
    newRequest.httpBody = myRequestData;
    
    newRequest.httpMethod = @"POST";
    [newRequest send];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    TTURLDataResponse *response =  (TTURLDataResponse *)request.response;  
    int status = [error code];
    NSLog(@"Error on BaseScene::serviceResultHandler. HTTP return status code: %d", status);
    
    NSLog(@"request didFailLoadWithError:%@", [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]);
}



@end
