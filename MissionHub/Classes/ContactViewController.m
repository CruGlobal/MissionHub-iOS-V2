//
//  ContactViewController.m
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactViewController.h"
#import "MissionHubAppDelegate.h"
#import "HJManagedImageV.h"
#import "CommentCell.h"
#import "SimpleCell.h"

@implementation ContactRequestDelegate

- (id) initWithArray:(NSMutableArray*)data data2:(NSMutableArray*)aData2 tableView:(UITableView*)aTableView {
    if (self = [super init]) {
          
        tempData = data;
        tempData2 = aData2;
        tempTableView = aTableView;
    }
    return self;
}

- (void) requestDidFinishLoad:(TTURLRequest*)request {
    TTURLJSONResponse* response = request.response;
    NSLog(@"requestDidStartLoad:%@", response.rootObject);   
    
    NSDictionary *tempDict = response.rootObject;
    NSArray *people = [tempDict objectForKey:@"people"];
    NSDictionary *personAndFormDict = [people objectAtIndex:0];
    NSDictionary *person = [personAndFormDict objectForKey:@"person"];
    NSDictionary *assignment = [person objectForKey:@"assignment"];
    
    NSArray *personAssignedToArray = [assignment objectForKey:@"person_assigned_to"];
    NSMutableString* personAssignedTo = [NSMutableString string];
    for (NSDictionary *dict in personAssignedToArray) {
        [personAssignedTo appendString:[NSString stringWithFormat:@"%@,", [dict objectForKey:@"name"]]];      
    }
    
    NSDictionary *location = [person objectForKey:@"location"];    
    
    NSArray *interestsArray = [person objectForKey:@"interests"];    
    NSMutableString* interests = [NSMutableString string];
	for (NSDictionary *dict in interestsArray) {
        [interests appendString:[NSString stringWithFormat:@"%@,", [dict objectForKey:@"name"]]];      
    }
    
    NSArray *educationsArray = [person objectForKey:@"education"];    
    NSString *highSchool = nil;
    NSString *college = nil;    
	for (NSDictionary *dict in educationsArray) {
        NSDictionary *school = [dict objectForKey:@"school"];
        if ([[dict objectForKey:@"type"] isEqualToString:@"High School"]) {
            highSchool = [school objectForKey:@"name"];
        }
        if ([[dict objectForKey:@"type"] isEqualToString:@"College"]) {
            college = [school objectForKey:@"name"];            
        }
        
    }

    [tempData addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Assigned To", @"label", personAssignedTo, @"value", nil]];
    [tempData addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"First Contact Date", @"label", [person objectForKey:@"first_contact_date"], @"value", nil]];    
    [tempData addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Phone Number", @"label", [person objectForKey:@"phone_number"], @"value", nil]];
    [tempData addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Email Address", @"label", [person objectForKey:@"email_address"], @"value", nil]];
    [tempData addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Birthday", @"label", [person objectForKey:@"birthday"], @"value", nil]];
    [tempData addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Interests", @"label", interests, @"value", nil]];    
    [tempData addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"High School", @"label", highSchool, @"value", nil]];
    [tempData addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"College", @"label",  college, @"value", nil]];
    [tempData addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Location", @"label", [location objectForKey:@"name"], @"value", nil]];
    
    NSArray *questions = [tempDict objectForKey:@"questions"];    
    NSArray *answers = [personAndFormDict objectForKey:@"form"];        

    for (NSDictionary *question in questions) {        
        for (NSDictionary *answer in answers) {
            
            NSString *answerId = [answer objectForKey:@"q"];
            NSString *questionId = [question objectForKey:@"id"];
            
            if ([answerId integerValue] == [questionId integerValue]) {
                if ([[answer objectForKey:@"a"] length] == 0) {
                    [tempData2 addObject: [NSDictionary dictionaryWithObjectsAndKeys: [question objectForKey:@"label"], @"label", @"not answered", @"value", nil]];                
                } else {
                    [tempData2 addObject: [NSDictionary dictionaryWithObjectsAndKeys: [question objectForKey:@"label"], @"label", [answer objectForKey:@"a"], @"value", nil]];                
                }
            }
        }
    }

    
    [tempTableView reloadData];
}

@end

@implementation ContactViewController

@synthesize personData;
@synthesize nameLbl;
@synthesize tableView;
@synthesize commentsArray;
@synthesize infoArray;
@synthesize surveyArray;
@synthesize simpleCell;
@synthesize commentCell;
@synthesize segmentedControl;
@synthesize placeHolderImageView;


- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query { 
    if (self = [super init]){ 
        self.personData =[query objectForKey:@"personData"]; 
    } 
    return self; 
} 

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
    
    commentsArray = [[NSMutableArray alloc] initWithCapacity:10];
    infoArray = [[NSMutableArray alloc] initWithCapacity:10];
    surveyArray = [[NSMutableArray alloc] initWithCapacity:10];    

//    [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Assigned to", CurrentUser.
//    dict = 
//            @"/opt/picture.png", @"Luca", 
//            @"/home/nico/birthday.png", @"Birthday Photo", 
//            @"/home/nico/birthday.png", @"Birthday Image", 
//            @"/home/marghe/pic.jpg", @"My Sister", nil];
    
    
    // Do any additional setup after loading the view from its nib.
    [nameLbl setText:[self.personData objectForKey:@"name"]];

    // Set user's image
    NSString *fbUrl = [NSString stringWithFormat:@"%@?type=large", [self.personData objectForKey:@"picture"]]; 
    NSURL * imageURL = [NSURL URLWithString: fbUrl];
    
    HJManagedImageV* mi = [[[HJManagedImageV alloc] initWithFrame:placeHolderImageView.frame] autorelease];;
    [self.view addSubview: mi];
    mi.url = imageURL;
    
    [AppDelegate.imageManager manage:mi];
    
    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/followup_comments/%@.json?access_token=%@", baseUrl, [self.personData objectForKey:@"id"], CurrentUser.accessToken];
    NSLog(@"request:%@", requestUrl);    
    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.response = [[[TTURLJSONResponse alloc] init] autorelease];
    [request send];
     
     requestUrl = [NSString stringWithFormat:@"%@/contacts/%@.json?access_token=%@", baseUrl, [self.personData objectForKey:@"id"], CurrentUser.accessToken];
     NSLog(@"request:%@", requestUrl);    
     request = [TTURLRequest requestWithURL: requestUrl delegate: [[ContactRequestDelegate alloc] initWithArray:infoArray data2:surveyArray tableView:self.tableView]];
     request.response = [[[TTURLJSONResponse alloc] init] autorelease];
     [request send];     
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLJSONResponse* response = request.response;
    NSLog(@"requestDidStartLoad:%@", response.rootObject);   
    
    NSArray *tempArray = response.rootObject;
    
	for (NSDictionary *tempDict in tempArray) {
        NSDictionary *comment = [tempDict objectForKey:@"followup_comment"];
        [commentsArray addObject: comment];
    }
    [tableView reloadData];
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

- (IBAction)onBackBtn:(id)sender {    
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"mh://contacts"]];    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (segmentedControl.selectedSegmentIndex == 1) {
        return [infoArray count];        
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        return [surveyArray count];                
    }
    
    return [commentsArray count];    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CommentCell";
    static NSString *CellIdentifier2 = @"SimpleCell";    
    
    UITableViewCell *cell = nil;
    
    // Dequeue or create a cell of the appropriate type.
    if (segmentedControl.selectedSegmentIndex == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
            cell = commentCell;
            self.commentCell = nil;
        }
        
        NSDictionary *tempDict = [commentsArray objectAtIndex: indexPath.row];
        NSDictionary *comment = [tempDict objectForKey:@"comment"];
        
        [(CommentCell*)cell setData: comment];
    }
        
    if (segmentedControl.selectedSegmentIndex == 1 || segmentedControl.selectedSegmentIndex == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"SimpleCell" owner:self options:nil];
            cell = simpleCell;
            self.simpleCell = nil;
        }
        NSDictionary *tempDict = nil;
        if (segmentedControl.selectedSegmentIndex == 1) {
            tempDict = [infoArray objectAtIndex: indexPath.row];        
        } else {
            tempDict = [surveyArray objectAtIndex: indexPath.row];        
        }
        [(SimpleCell*)cell setData: tempDict];
    }
    // Configure the cell.
    //cell.textLabel.text = [NSString stringWithFormat:@"%@", [comment objectForKey:@"comment"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60.0f;
}


#pragma mark - button events

- (IBAction)onCallBtn:(id)sender {
    
}

- (IBAction)onSmsBtn:(id)sender {
    
}

- (IBAction)onEmailBtn:(id)sender {
    
}

- (IBAction)onAssignBtn:(id)sender {
    
}

- (IBAction)onRejoicableBtn:(id)sender {
    
}

- (IBAction)onStatusBtn:(id)sender {
    
}

- (IBAction)onSaveBtn:(id)sender {
    
}

- (IBAction)onSegmentChange:(id)sender {    
        
    [tableView reloadData];
}


@end
