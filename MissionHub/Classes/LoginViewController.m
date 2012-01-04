//
//  LoginViewController.m
//  MissionHub
//
//  Created by David Ang on 12/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "PopupTTWebController.h"
#import "MissionHubAppDelegate.h"

@implementation LoginViewController

@synthesize aboutBtn;
@synthesize fbWebView, closeBtn;
@synthesize accesssGranted;
@synthesize webViewContainer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        TTDINFO(@"initWithNibName");
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
    TTDINFO(@"viewDidLoad");

    fbWebView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 290, 420)];
    [fbWebView setDelegate:self];    
    
    closeBtn = [TTButton buttonWithStyle:@"toolbarButton:" title:@"X"];  
    closeBtn.font = [UIFont systemFontOfSize:12.0f];
    [closeBtn addTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside]; 
    [closeBtn sizeToFit];
    
    CGRect btnFrame = closeBtn.frame;   
    btnFrame.origin.x = 260;
    btnFrame.origin.y = 10;    
    [closeBtn setFrame:btnFrame];
    
//    [fbWebView setHidden:YES];
//    [closeBtn setHidden:YES];

    webViewContainer = [[[TTView alloc] initWithFrame:CGRectMake(10, 10, 310, 440)] autorelease];
    UIColor* black = RGBCOLOR(158, 163, 172);    
    webViewContainer.style =  [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:5] next:
                               [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.5) blur:5 offset:CGSizeMake(1, 1) next:
                                [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0.15, 0.15, 0.15, 0.5) next:
                                 [TTSolidFillStyle styleWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.2] next:
                                  [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-0.15, -0.15, -0.15, -0.15) next:
                                   [TTSolidBorderStyle styleWithColor:[UIColor clearColor] width:0 next:nil]]]]]];
    
    //webViewContainer.alpha = 0.5f;
    //[webViewContainer setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
    webViewContainer.backgroundColor = [UIColor clearColor];
    
    //[view addSubview:webView];
    [self.view addSubview:webViewContainer];
    [webViewContainer setHidden:YES];
    
    [webViewContainer addSubview:fbWebView];
    [webViewContainer addSubview:closeBtn];
    
    [fbWebView setBackgroundColor:[UIColor whiteColor]];    
}

- (void)viewWillAppear:(BOOL)animated 
{
    NSLog(@"viewWillAppear");
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator.topViewController.navigationController setNavigationBarHidden:YES];  
    
    accesssGranted = NO;
}

- (void)viewDidUnload
{
    [self setAboutBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onAboutBtn:(id)sender {    
    TTOpenURL(@"http://www.missionhub.com?mobile=0"); 
    
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator.topViewController.navigationController setNavigationBarHidden:NO];   
}

- (IBAction)onLoginBtn:(id)sender {
    
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"base_url"];
    NSString *scope = [[AppDelegate config] objectForKey:@"oauth_scope"];
    NSString *redirectUrl = [NSString stringWithFormat:@"%@/oauth/done.json", baseUrl];
    
    NSString *authorizeUrl = [NSString stringWithFormat:@"%@/oauth/authorize?display=touch&simple=true&response_type=code&redirect_uri=%@&client_id=5&scope=%@", baseUrl, redirectUrl, scope];

    NSLog(@"%@", authorizeUrl);
//    TTOpenURL(authorizeUrl); 
//
//    TTNavigator *navigator = [TTNavigator navigator];
//    [navigator.topViewController.navigationController setNavigationBarHidden:NO];   
    
    NSURL *url = [NSURL URLWithString:authorizeUrl];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [fbWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
    //Load the request in the UIWebView.
    [fbWebView loadRequest:requestObj];
    //[self showActivityLabel];
    
//    [fbWebView setHidden:YES];
//    [closeBtn setHidden:YES];  
    [webViewContainer setHidden:NO];      

    webViewContainer.transform = CGAffineTransformMakeScale(0.01f, 0.01f);

     // Bounce it slightly large 
     [UIView animateWithDuration:0.25f 
                      animations:^{webViewContainer.transform = 
                          CGAffineTransformMakeScale(1.15f, 1.15f);} 
                      completion:^(BOOL done){ 
                          // Shrink it back to normal 
                          [UIView animateWithDuration:0.2f 
                                           animations:^{webViewContainer.transform = 
                                               CGAffineTransformIdentity;} 
                                           completion:^(BOOL done){ 
                                               self.navigationItem.rightBarButtonItem.enabled = YES; 
                                           }];}];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL* url = [request  URL];
    NSLog(@"shouldStartLoadWithRequest: %@", [url absoluteString]);
    
    NSRange aRange = [[url absoluteString] rangeOfString:@"facebook.com/oauth/authorize"];
    if (aRange.location != NSNotFound) {    
        [self showActivityLabel];
    }
    
    aRange = [[url absoluteString] rangeOfString:@"facebook.com/login"];
    if (aRange.location != NSNotFound) {    
        [self showActivityLabel];
    }
    
    return YES;
}

//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    NSURL* url = [webView.request  URL];
//    NSLog(@"webViewDidStartLoad: %@", [url absoluteString]);
//
//    
//    //NSLog(@"webViewDidStartLoad. request url was: %@",     webView.request.URL);    
//    
//    NSRange aRange = [[webView.request.URL absoluteString] rangeOfString:@"facebook"];
//    if (aRange.location != NSNotFound) {    
//        [self showActivityLabel];
//    }
//    
//
////    [fbWebView setHidden:YES];
////    [closeBtn setHidden:YES];    
//}

- (void) closeWebView {
//    [fbWebView setHidden:YES];
//    [closeBtn setHidden:YES];
    [webViewContainer setHidden:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad. request url was: %@",     webView.request.URL);    
    [self hideActivityLabel];
    
    [webView setScalesPageToFit:YES];
    
    NSRange aRange = [[webView.request.URL absoluteString] rangeOfString:@"facebook"];
    NSRange aRange2 = [[webView.request.URL absoluteString] rangeOfString:@"survey"];    
    if (aRange.location == NSNotFound && aRange2.location == NSNotFound && !accesssGranted) {
        
        NSArray *parameters = [[webView.request.URL query] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
        NSMutableDictionary *keyValueParm = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < [parameters count]; i=i+2) {
            [keyValueParm setObject:[parameters objectAtIndex:i+1] forKey:[parameters objectAtIndex:i]];
        }
        
        NSString *baseUrl = [[AppDelegate config] objectForKey:@"oauth_url"];
        NSString *authorization = [keyValueParm objectForKey:@"authorization"];
        
        if (authorization) {
            NSString *grantUrl = [NSString stringWithFormat:@"%@/grant.json?authorization=%@", baseUrl, authorization];
            
            TTURLRequest *request = [TTURLRequest requestWithURL: grantUrl delegate: self];
            request.response = [[[TTURLJSONResponse alloc] init] autorelease];
            [request send];
            
            accesssGranted = YES;
            NSLog(@"Access Granted * Access Granted * Access Granted * Access Granted * Access Granted * Access Granted * Access Granted");

            [webViewContainer setHidden:YES];
            
            [self showActivityLabel];
        }
    }
  
}

- (void)requestDidStartLoad:(TTURLRequest*)request {
    NSLog(@"requestDidStartLoad: %@", request.urlPath);
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    
    NSDictionary* response = ((TTURLJSONResponse*)request.response).rootObject;
    
    NSLog(@"requestDidFinishLoad:%@", response);
    NSString *accessToken = [response objectForKey:@"access_token"];
    
    // After user logs in through FB.
    if (accessToken) {
        // [[TTNavigator navigator].topViewController.navigationController popViewControllerAnimated:YES];
        [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://main"]];
        
        NSLog(@"Saving access token to NSUserDefaults.");
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:accessToken forKey:@"accessToken"];			
        
        CurrentUser.data = [response objectForKey:@"person"];
        CurrentUser.accessToken = accessToken;
        
        [self hideActivityLabel];
    } else {
        
        NSString *baseUrl = [[AppDelegate config] objectForKey:@"base_url"];
        NSString *oauthUrl = [[AppDelegate config] objectForKey:@"oauth_url"];        
        NSString *scope = [[AppDelegate config] objectForKey:@"oauth_scope"];
        NSString *clientSecret = [[AppDelegate config] objectForKey:@"oauth_client_secret"];    
        NSString *redirectUrl = [NSString stringWithFormat:@"%@/oauth/done.json", baseUrl];
        NSString *code = [response objectForKey: @"code"];
        NSString *accessTokenUrl = [NSString stringWithFormat:@"%@/access_token?", oauthUrl];
        NSString *myRequestString = [NSString stringWithFormat:@"grant_type=authorization_code&redirect_uri=%@&client_id=5&scope=%@&client_secret=%@&code=%@", redirectUrl, scope, clientSecret, code];
        
        NSData *myRequestData = [ NSData dataWithBytes: [ myRequestString UTF8String ] length: [ myRequestString length ] ];
        
        
        TTURLRequest *newRequest = [TTURLRequest requestWithURL: accessTokenUrl delegate: self];
        newRequest.contentType=@"application/x-www-form-urlencoded";    
        
        NSLog(@"request url:%@", request.urlPath);    
        newRequest.response = [[[TTURLJSONResponse alloc] init] autorelease];
        
        newRequest.httpBody = myRequestData;
        
        newRequest.httpMethod = @"POST";
        [newRequest send];
    }
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    //TTURLDataResponse *response =  (TTURLDataResponse *)request.response;  
    int status = [error code];
    NSLog(@"didFailLoadWithError. HTTP return status code: %d", status);

    [self hideActivityLabel];
}

- (void)dealloc {
    [aboutBtn release];
    [super dealloc];
}
@end
