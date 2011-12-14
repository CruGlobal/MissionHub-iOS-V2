//
//  ContactViewController.m
//  MissionHub
//
//  Created by David Ang on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactViewController.h"
#import "HJManagedImageV.h"
#import "CommentCell.h"
#import "SimpleCell.h"

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
//@synthesize assignBtn;


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

    // Do any additional setup after loading the view from its nib.
    [nameLbl setText:[self.personData objectForKey:@"name"]];

    // Set user's image
    NSString *fbUrl = [NSString stringWithFormat:@"%@?type=large", [self.personData objectForKey:@"picture"]]; 
    NSURL * imageURL = [NSURL URLWithString: fbUrl];
    
    HJManagedImageV* mi = [[[HJManagedImageV alloc] initWithFrame:placeHolderImageView.frame] autorelease];
    [tableView addSubview: mi];
    mi.url = imageURL;
    
    [AppDelegate.imageManager manage:mi];
   
    [self makeHttpRequest:[NSString stringWithFormat:@"followup_comments/%@.json", [self.personData objectForKey:@"id"]] identifier:@"followup_comments"];
    [self makeHttpRequest:[NSString stringWithFormat:@"contacts/%@.json", [self.personData objectForKey:@"id"]] identifier:@"contacts"];     
}

- (void) handleRequestResult:(id *)aResult identifier:(NSString*)aIdentifier {
    NSDictionary *result = aResult;    
    if ([aIdentifier isEqualToString:@"followup_comments"]) {
        NSArray *comments = [result objectForKey:@"followup_comments"];
        
        for (NSDictionary *tempDict in comments) {
            NSDictionary *comment = [tempDict objectForKey:@"followup_comment"];
            [commentsArray addObject: comment];
        }
    } else if ([aIdentifier isEqualToString:@"contacts"]) {
        NSArray *people = [result objectForKey:@"contacts"];
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
        
        [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Assigned To", @"label", personAssignedTo, @"value", nil]];
        [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"First Contact Date", @"label", [person objectForKey:@"first_contact_date"], @"value", nil]];    
        [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Phone Number", @"label", [person objectForKey:@"phone_number"], @"value", nil]];
        [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Email Address", @"label", [person objectForKey:@"email_address"], @"value", nil]];
        [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Birthday", @"label", [person objectForKey:@"birthday"], @"value", nil]];
        [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Interests", @"label", interests, @"value", nil]];    
        [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"High School", @"label", highSchool, @"value", nil]];
        [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"College", @"label",  college, @"value", nil]];
        [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Location", @"label", [location objectForKey:@"name"], @"value", nil]];
        
        NSArray *questions = [result objectForKey:@"questions"];    
        NSArray *answers = [personAndFormDict objectForKey:@"form"];        
        
        for (NSDictionary *question in questions) {        
            for (NSDictionary *answer in answers) {
                
                NSString *answerId = [answer objectForKey:@"q"];
                NSString *questionId = [question objectForKey:@"id"];
                
                if ([answerId integerValue] == [questionId integerValue]) {
                    if ([[answer objectForKey:@"a"] length] == 0) {
                        [surveyArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: [question objectForKey:@"label"], @"label", @"not answered", @"value", nil]];                
                    } else {
                        [surveyArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: [question objectForKey:@"label"], @"label", [answer objectForKey:@"a"], @"value", nil]];                
                    }
                }
            }
        }

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
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"mh://contacts"] applyAnimated:YES]];    
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

#pragma mark - UITextView delegate, should hide the keyboard on done

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


#pragma mark - button events

- (IBAction)onCallBtn:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:99022002"]]; 
}

- (IBAction)onSmsBtn:(id)sender {
    NSString *path = [NSString stringWithFormat:@"mh://composeSms?to=%@", [[self.personData objectForKey:@"name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];    
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:path] applyAnimated:YES]];           
}

- (IBAction)onEmailBtn:(id)sender {
    NSString *path = [NSString stringWithFormat:@"mh://composeEmail?to=%@", [[self.personData objectForKey:@"name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:path] applyAnimated:YES]];       
}

- (IBAction)onAssignBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn.currentTitle isEqualToString:@"Assign"]) {
        [self makeHttpRequest:@"contact_assignments.json" identifier:@"assign" postData: [NSDictionary dictionaryWithObjectsAndKeys: 
                                                                                          CurrentUser.userId, @"assign_to_id",
                                                                                          @"leader", @"type",                                                             
                                                                                          [self.personData objectForKey:@"id"], @"id", nil]];
        [btn setTitle:@"Unassign" forState:UIControlStateNormal];
    } else {
        [self makeHttpRequest:[NSString stringWithFormat:@"contact_assignments/%@.json", [self.personData objectForKey:@"id"]]
                   identifier:@"assign" postData: [NSDictionary dictionaryWithObjectsAndKeys: @"delete", @"_method", [self.personData objectForKey:@"id"], @"ids", nil]];
        [btn setTitle:@"Assign" forState:UIControlStateNormal];        
    }
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
