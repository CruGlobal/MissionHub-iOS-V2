//
//  LoginViewController.m
//  MissionHub
//
//  Created by David Ang on 12/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "MissionHubAppDelegate.h"

#import "UIViewController+MJPopupViewController.h"
#import "TipViewController.h"


@implementation LoginViewController

@synthesize aboutBtn;
@synthesize fbWebView;
@synthesize accesssGranted;
@synthesize isCheckingForAccessToken;
@synthesize fbWebViewContainer;

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

    if ([[UIDevice currentDevice].model hasPrefix:@"iPhone"]) {
        fbWebView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 290, 420)];
    } else {
        fbWebView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 740, 970)];
    }
    [fbWebView setBackgroundColor:[UIColor whiteColor]];
    [fbWebView setDelegate:self];

    UIButton *closeBtn = [TTButton buttonWithStyle:@"toolbarButton:" title:@"X"];
    closeBtn.font = [UIFont systemFontOfSize:12.0f];
    [closeBtn addTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn sizeToFit];

    // Adjust close button position
    CGRect btnFrame = closeBtn.frame;
    btnFrame.origin.x = 710;
    btnFrame.origin.y = 10;
    [closeBtn setFrame:btnFrame];
    
    if ([[UIDevice currentDevice].model hasPrefix:@"iPhone"]) {
        btnFrame.origin.x = 260;
    }      

    if ([[UIDevice currentDevice].model hasPrefix:@"iPhone"]) {
        fbWebViewContainer = [[TTView alloc] initWithFrame:CGRectMake(10, 10, 310, 440)];        
    } else {
        fbWebViewContainer = [[TTView alloc] initWithFrame:CGRectMake(10, 10, 760, 990)];        
    }    

    fbWebViewContainer.style =  [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:5] next:
                               [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.5) blur:5 offset:CGSizeMake(1, 1) next:
                                [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0.15, 0.15, 0.15, 0.5) next:
                                 [TTSolidFillStyle styleWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.2] next:
                                  [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-0.15, -0.15, -0.15, -0.15) next:
                                   [TTSolidBorderStyle styleWithColor:[UIColor clearColor] width:0 next:nil]]]]]];
    [fbWebViewContainer setBackgroundColor:[UIColor clearColor]];

    [fbWebViewContainer addSubview:fbWebView];
    [fbWebViewContainer addSubview:closeBtn];
    [self.view addSubview:fbWebViewContainer];

    [fbWebViewContainer setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator.topViewController.navigationController setNavigationBarHidden:YES];

    accesssGranted = NO;
    isCheckingForAccessToken = NO;
    
    // Check if we already have an accessToken
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CurrentUser.accessToken = [userDefaults stringForKey:@"accessToken"];	
    if (CurrentUser.accessToken) {
        NSLog(@"Found accesstoken: %@", CurrentUser.accessToken);
        
        NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
        NSString *requestUrl = [NSString stringWithFormat:@"%@/people/me.json?access_token=%@", baseUrl, CurrentUser.accessToken];
        
        TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
        request.cachePolicy = TTURLRequestCachePolicyNone;        
        request.response = [[TTURLJSONResponse alloc] init] ;
        [request send];
        
        isCheckingForAccessToken = YES;
        
        [self showActivityLabel:NO];
    }

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
//    TipViewController *tipViewController = [[TipViewController alloc] initWithNibName:@"TipViewController" bundle:nil];
//    [self presentPopupViewController:tipViewController animationType:MJPopupViewAnimationFade];

    
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
    NSURL *url = [NSURL URLWithString:authorizeUrl];

    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [fbWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
    //Load the request in the UIWebView.
    [fbWebView loadRequest:requestObj];
    [fbWebViewContainer setHidden:NO];

    fbWebViewContainer.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
     // Bounce it slightly large
     [UIView animateWithDuration:0.25f
      animations:^{fbWebViewContainer.transform =
          CGAffineTransformMakeScale(1.15f, 1.15f);}
      completion:^(BOOL done){
          // Shrink it back to normal
          [UIView animateWithDuration:0.2f
               animations:^{fbWebViewContainer.transform =
                   CGAffineTransformIdentity;}
               completion:^(BOOL done){
                   self.navigationItem.rightBarButtonItem.enabled = YES;
               }];}];
}

#pragma mark UIWebView delegates

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSURL* url = [request  URL];
    NSLog(@"shouldStartLoadWithRequest: %@", [url absoluteString]);
    
    // Detect a series of urls to find out if the login process is finish
    // this is the only way i could think of to handle the facebook and mission hub login
    NSRange aRange = [[url absoluteString] rangeOfString:@"facebook.com/oauth/authorize"];
    if (aRange.location != NSNotFound) {
        [self showActivityLabel:NO];
    }

    aRange = [[url absoluteString] rangeOfString:@"facebook.com/login"];
    if (aRange.location != NSNotFound) {
        [self showActivityLabel:NO];
    }

    aRange = [[url absoluteString] rangeOfString:@"missionhub.com/oauth/authorize"];
    if (aRange.location != NSNotFound) {
        [self showActivityLabel:NO];
    }

    aRange = [[url absoluteString] rangeOfString:@"missionhub.com/users/auth/facebook"];
    if (aRange.location != NSNotFound) {
        [self showActivityLabel:NO];
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSURL* url = [webView.request  URL];
    NSLog(@"webViewDidStartLoad: %@", [url absoluteString]);
}

- (void) closeWebView {
    [fbWebViewContainer setHidden:YES];
    [self hideActivityLabel];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad. request url was: %@",     webView.request.URL);
    [self hideActivityLabel];

    [webView setScalesPageToFit:YES];

    NSRange aRange = [[webView.request.URL absoluteString] rangeOfString:@"facebook"];
    if (aRange.location == NSNotFound && !accesssGranted) {

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
            request.response = [[TTURLJSONResponse alloc] init];
            [request send];

            accesssGranted = YES;
            NSLog(@"Access Granted * Access Granted * Access Granted * Access Granted * Access Granted * Access Granted * Access Granted");

            [fbWebViewContainer setHidden:YES];

            [self showActivityLabel];
        }
    }

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError: %d", [error code]);
    
    [self hideActivityLabel];

    [[NiceAlertView alloc] initWithText:@"There was an error. Please check your internet connection and try again."];
}


#pragma mark TTURLRequest delegates

- (void)requestDidStartLoad:(TTURLRequest*)request {
    NSLog(@"requestDidStartLoad: %@", request.urlPath);
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {

    if (isCheckingForAccessToken) {
        TTURLJSONResponse* response = request.response;
        NSLog(@"requestDidFinishLoad for isCheckingForAccessToken: %@", response.rootObject);    
        //TTDASSERT([response.rootObject isKindOfClass:[NSArray class]]);
        
        NSDictionary *result = response.rootObject;
        [User sharedUser].data = [[result objectForKey:@"people"] objectAtIndex:0];
        
        [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://main"]];    
        
        [self hideActivityLabel];
    } else {

        NSDictionary* response = ((TTURLJSONResponse*)request.response).rootObject;

        NSLog(@"requestDidFinishLoad:%@", response);
        NSString *accessToken = [response objectForKey:@"access_token"];
        NSDictionary *error = [response objectForKey:@"error"];
        
        // check for error (eg, permission denied)
        if (error) {
            NSString *msg = [error objectForKey:@"message"];
            [[NiceAlertView alloc] initWithText:msg];
        } else {
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

                NSLog(@"request url was:%@", request.urlPath);
                newRequest.response = [[TTURLJSONResponse alloc] init];

                newRequest.httpBody = myRequestData;

                newRequest.httpMethod = @"POST";
                [newRequest send];
            }
        }
    }
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
    int status = [error code];
    NSLog(@"didFailLoadWithError. HTTP return status code: %d", status);
    
//    if (isCheckingForAccessToken) {
//        int status = [error code];
//        NSLog(@"didFailLoadWithError HTTP return status code: %d", status);    
//        
//        if (status == 401) { // token has expired / invalid authentication
//            NSLog(@"... access token has been invalidated");    
//            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
//            
//            [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://login"]];    
//        }
//    }

    [self hideActivityLabel];
}

- (void)dealloc {
}
@end
