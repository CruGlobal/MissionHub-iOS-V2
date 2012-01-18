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
@synthesize commentTextView;
@synthesize statusBtn;
@synthesize rejoicablesView;
@synthesize rejoicablesArray;
@synthesize statusSelected;
@synthesize assignBtn;
@synthesize imagePicker;
    
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

- (void) viewDidLoad {
    [super viewDidLoad];
    
    commentsArray = [[NSMutableArray alloc] initWithCapacity:10];
    infoArray = [[NSMutableArray alloc] initWithCapacity:10];
    surveyArray = [[NSMutableArray alloc] initWithCapacity:10];    
    rejoicablesArray = [[NSMutableArray alloc] initWithCapacity:3];    
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsImageEditing = YES;
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    // Do any additional setup after loading the view from its nib.
    [nameLbl setText:[self.personData objectForKey:@"name"]];

    // Set user's image
    NSString *picture = [self.personData objectForKey:@"picture"];
    if ([picture length] != 0) {
        NSString *fbUrl = [NSString stringWithFormat:@"%@?type=large", picture]; 
        NSURL * imageURL = [NSURL URLWithString: fbUrl];
        
        // Do we need to check if this has been allocated before?
        HJManagedImageV* mi = [[[HJManagedImageV alloc] initWithFrame:placeHolderImageView.frame] autorelease];
        [tableView addSubview: mi];
        mi.url = imageURL;
        
        [AppDelegate.imageManager manage:mi];
        
        [placeHolderImageView setHidden: YES];
    }
   
    [self makeHttpRequest:[NSString stringWithFormat:@"followup_comments/%@.json", [self.personData objectForKey:@"id"]] identifier:@"followup_comments"];
    [self makeHttpRequest:[NSString stringWithFormat:@"contacts/%@.json", [self.personData objectForKey:@"id"]] identifier:@"contacts"];     
    
    // tuck away the rejoicable selection
    CGRect frame = self.rejoicablesView.frame;
    frame.origin.x = -400.0f;
    self.rejoicablesView.frame = frame;
    
    NSDictionary *assignment = [self.personData objectForKey:@"assignment"];
    if ([[assignment objectForKey:@"person_assigned_to"] count] == 0) {
        [assignBtn setTitle: @"Assign" forState:UIControlStateNormal];
    }

    [self showActivityLabel:NO];
}

- (void) handleRequestResult:(id *)aResult identifier:(NSString*)aIdentifier {
    NSDictionary *result = (NSDictionary*)aResult;    
    if ([aIdentifier isEqualToString:@"followup_comments"]) {
        [commentsArray removeAllObjects];
        
        NSArray *comments = [result objectForKey:@"followup_comments"];
        
        for (NSDictionary *tempDict in comments) {
            NSDictionary *comment = [tempDict objectForKey:@"followup_comment"];
            [commentsArray addObject: comment];
        }
        
        [self hideActivityLabel];
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
        if ([personAssignedTo length] != 0) {
            [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Assigned To", @"label", personAssignedTo, @"value", nil]];
        }
        if ([person objectForKey:@"first_contact_date"]) {
            [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"First Contact Date", @"label", [person objectForKey:@"first_contact_date"], @"value", nil]];    
        }
        if ([person objectForKey:@"phone_number"]) {
            [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Phone Number", @"label", [person objectForKey:@"phone_number"], @"value", nil]];
        }        
        [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Email Address", @"label", [person objectForKey:@"email_address"], @"value", nil]];
        if ([person objectForKey:@"birthday"]) {
            [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Birthday", @"label", [person objectForKey:@"birthday"], @"value", nil]];
        }
        if ([interests length] != 0) {
            [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Interests", @"label", interests, @"value", nil]];    
        }
        if (highSchool != nil) {
            [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"High School", @"label", highSchool, @"value", nil]];
        }
        if (college != nil) {
            [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"College", @"label",  college, @"value", nil]];
        }
        if ([location objectForKey:@"name"]) {
            [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Location", @"label", [location objectForKey:@"name"], @"value", nil]];
        }
        
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

    } else if ([aIdentifier isEqualToString:@"onSaveBtn"]) {
        //[self makeHttpRequest:[NSString stringWithFormat:@"followup_comments/%@.json", [self.personData objectForKey:@"id"]] identifier:@"followup_comments"];   
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
        [(CommentCell*)cell setData: tempDict];
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

#pragma mark UIImagePickerControllerDelegate methods

- (void) imagePickerController:(UIImagePickerController *) picker didFinishPickingImage:(UIImage *) image editingInfo:(NSDictionary *) editingInfo {

    [placeHolderImageView setImage:image forState:UIControlStateNormal];
    [self dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    [self dismissModalViewControllerAnimated:YES];
}



#pragma mark - button events

- (IBAction)onBackBtn:(id)sender {
    // [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"mh://contacts"] applyAnimated:YES]];    
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"mh://nib/ContactsViewController" ] applyAnimated:YES]];    
    [[TTURLRequestQueue mainQueue] cancelRequestsWithDelegate:self]; 
}

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

- (IBAction)onShowRejoicablesBtn:(id)sender {
    CGRect frame = self.rejoicablesView.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    
    if (frame.origin.x == 0) {
        frame.origin.x = -480.0f;        
    } else {
        frame.origin.x = 0;
    }

    self.rejoicablesView.frame = frame;
    
    // To autorelease the Msg, define stop selector
    //[UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    [UIView commitAnimations];
}

- (IBAction)onRejoicableBtn:(id)sender {
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    if (btn.tag == 1) {
        if (btn.selected) {
            [rejoicablesArray addObject:@"spiritual_conversation"];   
        } else {
            [rejoicablesArray removeObject:@"spiritual_conversation"];
        }
    } else if (btn.tag == 2) {
        if (btn.selected) {
            [rejoicablesArray addObject:@"prayed_to_receive"];        
        } else {
            [rejoicablesArray removeObject:@"prayed_to_receive"];        
        }
    } else if (btn.tag == 3) {
        if (btn.selected) {
            [rejoicablesArray addObject:@"gospel_presentation"];                
        } else {
            [rejoicablesArray removeObject:@"gospel_presentation"];                
        }
    }

}

- (IBAction)onStatusBtn:(id)sender {
    UIActionSheet *statusSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Status" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil 
                                                   otherButtonTitles:@"Uncontacted", @"Attempted Contact", @"Contacted", @"Completed", @"Do Not Contact", nil];
    [statusSheet showInView:self.view];
    [statusSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];

    [statusBtn setTitle: title forState:UIControlStateNormal];
    if ([title isEqualToString:@"Attempted Contact"]) {
        statusSelected = @"attempted_contact";
    } else if ([title isEqualToString:@"Contacted"]) {
        statusSelected = @"contacted";        
    } else if ([title isEqualToString:@"Completed"]) {
        statusSelected = @"completed";
    } else if ([title isEqualToString:@"Uncontacted"]) {
        statusSelected = @"uncontacted";
    } else if ([title isEqualToString:@"Do Not Contact"]) {
        statusSelected = @"do_not_contact";        
    }
}

- (IBAction)onSaveBtn:(id)sender {
    if ([self.statusSelected length] == 0) {
        [[[NiceAlertView alloc] initWithText:@"You need to set a status before you can save."] autorelease];
        return;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: 
                        [NSDictionary dictionaryWithObjectsAndKeys: 
                            CurrentUser.orgId, @"organization_id",
                            CurrentUser.userId, @"commenter_id",
                            self.statusSelected, @"status",                         
                            [self.personData objectForKey:@"id"], @"contact_id", 
                            commentTextView.text, @"comment", nil] , @"followup_comment", 
                         [NSArray arrayWithArray:rejoicablesArray], @"rejoicables", nil];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString *jsonString = [jsonWriter stringWithObject:params];
    [self makeHttpRequest:@"followup_comments.json" identifier:@"onSaveBtn" postData: [NSDictionary dictionaryWithObjectsAndKeys: 
                                                                                      jsonString, @"json",                                                                                               
                                                                                      CurrentUser.userId, @"commenter_id",
                                                                                      commentTextView.text, @"comment",                                                                                      
                                                                                      [self.personData objectForKey:@"id"], @"contact_id", nil]];


    
    // unselect all rejoicable buttons
    for(UIView *subview in [rejoicablesView subviews]) {
       if([subview isKindOfClass:[UIButton class]]) {
           UIButton *btn = (UIButton*)subview;
           btn.selected = NO;    
       }
    }

    
    NSDictionary *commenter = [NSDictionary dictionaryWithObjectsAndKeys: CurrentUser.name, @"name", CurrentUser.picture, @"picture", nil];
    NSMutableArray *rejoicables = [[NSMutableArray alloc] initWithCapacity:3];
    for(NSString *rejoicable in rejoicablesArray) {
        [rejoicables addObject: [NSDictionary dictionaryWithObjectsAndKeys:rejoicable, @"what", nil]];
    }

    NSDictionary *comment = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSDictionary dictionaryWithObjectsAndKeys: 
                              commentTextView.text, @"comment",
                              @"few seconds ago", @"created_at_words",
                              self.statusSelected, @"status",
                              commenter, @"commenter", nil], @"comment",
                              rejoicables, @"rejoicables",
                              nil];
    
    
//    "followup_comment" =             {
//        comment =                 {
//            comment = "";
//            commenter =                     {
//                id = 2160584;
//                name = "David Ang";
//                picture = "http://graph.facebook.com/1322439723/picture";
//            };
//            "contact_id" = 1744343;
//            "created_at" = "2011-12-27 20:09:33 UTC";
//            "created_at_words" = "15 days ago";
//            id = 55;
//            "organization_id" = 1;
//            status = "attempted_contact";
//            "updated_at" = "2011-12-27 20:09:33 UTC";
//        };
//        rejoicables =                 (
//                                       {
//                                           id = 68;
//                                           what = "gospel_presentation";
//                                       },
//                                       {
//                                           id = 69;
//                                           what = "prayed_to_receive";
//                                       }
//                                       );
//    };
    
    [commentsArray insertObject:comment atIndex:0];
    
    NSLog(@"%@",  [jsonWriter stringWithObject:comment]);
    [tableView reloadData];
    
    
    [commentTextView resignFirstResponder];
    [commentTextView setText:@""];
    [rejoicablesArray removeAllObjects];
    self.statusSelected = @"";
}

- (IBAction)onSegmentChange:(id)sender {    
        
    [tableView reloadData];
}

- (IBAction)onPlaceHolderImageBtn:(id)sender {
    [self presentModalViewController: imagePicker animated:YES];
}


@end
