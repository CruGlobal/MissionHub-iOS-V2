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
@synthesize email;
@synthesize phoneNo;
@synthesize shouldRefresh;
@synthesize facebookBtn;

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    if (self = [super init]){
        self.personData =[query objectForKey:@"personData"];
    }
    return self;
}


#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];

    commentsArray = [[NSMutableArray alloc] initWithCapacity:10];
    infoArray = [[NSMutableArray alloc] initWithCapacity:10];
    surveyArray = [[NSMutableArray alloc] initWithCapacity:10];
    rejoicablesArray = [[NSMutableArray alloc] initWithCapacity:3];

    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setAllowsImageEditing:YES];
    [imagePicker setDelegate:self];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }

    shouldRefresh = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Do any additional setup after loading the view from its nib.
    if (shouldRefresh) {
        [nameLbl setText:[personData objectForKey:@"name"]];
        
        NSString *gender = [personData objectForKey:@"gender"];
//        placeHolderImageView.layer.borderColor = [UIColor blackColor].CGColor;
//        placeHolderImageView.layer.borderWidth = 2;

        // Set user's image
        NSString *picture = [self.personData objectForKey:@"picture"];
        if ([picture length] != 0) {
            
            NSString *pictureUrl = [NSString stringWithFormat:@"%@?type=large", picture];
            
            TTImageView* profileImageView = [[TTImageView alloc] initWithFrame:placeHolderImageView.frame];
            profileImageView.defaultImage = placeHolderImageView.imageView.image;

            if([gender isKindOfClass:[NSString class]] && [gender isEqualToString:@"female"]) {
                // replace male placeholder image when contact is a female
               profileImageView.defaultImage = [UIImage imageNamed:@"facebook_female.gif"];
            }
            
            profileImageView.contentMode = UIViewContentModeScaleAspectFit;
            profileImageView.urlPath = pictureUrl;
           [profileImageView setDelegate: self];
//            profileImageView.layer.borderColor = [UIColor blackColor].CGColor;
//            profileImageView.layer.borderWidth = 2;

            [[[self.view subviews] objectAtIndex:0] addSubview: profileImageView];            
//            if (profileImageView.image) {
//                NSLog(@"exists: %f", profileImageView.image.size.width);
//            } else{
//                NSLog(@"NOT exists");
//            }

            [placeHolderImageView setHidden: YES];
                
        } else if([gender isKindOfClass:[NSString class]] && [gender isEqualToString:@"female"]) {
            // replace male placeholder image when contact is a female
            placeHolderImageView.imageView.image = [UIImage imageNamed:@"facebook_female.gif"];
        }

        [self makeHttpRequest:[NSString stringWithFormat:@"followup_comments/%@.json", [self.personData objectForKey:@"id"]] identifier:@"followup_comments"];
        [self makeHttpRequest:[NSString stringWithFormat:@"contacts/%@.json", [self.personData objectForKey:@"id"]] identifier:@"contacts"];

        // tuck away the rejoicable selection
        CGRect frame = self.rejoicablesView.frame;
        frame.origin.x = -400.0f;
        self.rejoicablesView.frame = frame;

        // set the assign button
        NSDictionary *assignment = [self.personData objectForKey:@"assignment"];
        if ([[assignment objectForKey:@"person_assigned_to"] count] == 0) {
            [assignBtn setTitle: @"Assign" forState:UIControlStateNormal];
        }

        [self showActivityLabel:NO];
        
        shouldRefresh = NO;
    }

    [rejoicablesView setHidden:YES];

    [facebookBtn setHidden:NO];
    if ([personData objectForKey:@"fb_id"] == nil) {
        [facebookBtn setHidden:YES];
    }   
    
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator.topViewController.navigationController setNavigationBarHidden:YES];
}

- (void)imageViewDidStartLoad:(TTImageView*)imageView {
    NSLog(@"imageViewDidStartLoad frame width: %f, image: %f", imageView.frame.size.width, imageView.image.size.width);
}

- (void)imageView:(TTImageView*)imageView didLoadImage:(UIImage*)image {
    NSLog(@"imageView didLoadImage frame width: %f, image: %f", imageView.frame.size.width, image.size.width);

// Fit TTImageView frame to image
//    CGFloat sx = imageView.frame.size.width / image.size.width;
//    CGFloat sy = imageView.frame.size.height / image.size.height;
//    
//    CGFloat finalWidth = 0;
//    CGFloat finalHeight = 0;
//    
//    if (image.size.width > imageView.frame.size.width) {
//        CGFloat ratio = sx;
//        finalHeight = image.size.height * ratio;
//        finalWidth = image.size.width * ratio;
//    }
//    
//    CGRect frame = imageView.frame;
//    frame = CGRectMake(frame.origin.x, frame.origin.y, finalWidth, finalHeight);
//    [imageView setFrame:frame];
}

- (void) handleRequestResult:(NSDictionary *)aResult identifier:(NSString*)aIdentifier {
    NSDictionary *result = aResult;
    // If we're receiving the followup comments
    if ([aIdentifier isEqualToString:@"followup_comments"]) {
        [commentsArray removeAllObjects];

        NSArray *comments = [result objectForKey:@"followup_comments"];

        for (NSDictionary *tempDict in comments) {
            NSDictionary *comment = [tempDict objectForKey:@"followup_comment"];
            [commentsArray addObject: comment];
        }
        
        if ([commentsArray count] == 0) {
            [commentsArray addObject: [NSDictionary dictionaryWithObjectsAndKeys:                                      
                                       [NSDictionary dictionaryWithObjectsAndKeys: @"No Previous Comments", @"comment", nil],
                                        @"comment", nil]];
        }

        [self hideActivityLabel];
    } else if ([aIdentifier isEqualToString:@"contacts"]) {
        // we receive contact details
        
        [infoArray removeAllObjects];
        [surveyArray removeAllObjects];
        
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
            phoneNo = [person objectForKey:@"phone_number"];
            [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Phone Number", @"label", [person objectForKey:@"phone_number"], @"value", nil]];
        }
        if ([person objectForKey:@"email_address"]) {
            email = [person objectForKey:@"email_address"];
            [infoArray addObject: [NSDictionary dictionaryWithObjectsAndKeys: @"Email Address", @"label", [person objectForKey:@"email_address"], @"value", nil]];
        }
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
        
        if ([person objectForKey:@"status"]) {
            statusSelected = [person objectForKey:@"status"];
            // capitalize first letter
            NSString *statusBtnTitle = [statusSelected stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[statusSelected  substringToIndex:1] capitalizedString]];
            statusBtnTitle = [statusBtnTitle stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            [statusBtn setTitle: statusBtnTitle forState:UIControlStateNormal];
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

- (void) dealloc {
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) uploadPersonPhoto {
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(placeHolderImageView.imageView.image)];

    NSString *baseUrl = [[AppDelegate config] objectForKey:@"api_url"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/contacts/%@/photo?org_id=%@&access_token=%@", baseUrl, [personData objectForKey:@"id"], CurrentUser.orgId, CurrentUser.accessToken];
    NSLog(@"making http POST request: %@", requestUrl);

    TTURLRequest *request = [TTURLRequest requestWithURL: requestUrl delegate: self];
    request.response = [[TTURLJSONResponse alloc] init];
    request.httpMethod = @"POST";
    request.cachePolicy = TTURLRequestCachePolicyNone;

    [request addFile:imageData mimeType:@"image/png" fileName:@"image"];
    [request send];
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

    [self uploadPersonPhoto];
    [self dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Messaging and MFMailComposeViewControllerDelegate methods

-(void)displayMailComposerSheet {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;

    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:email];         
    [picker setToRecipients:toRecipients];
    
//  [picker setSubject:@""];            
//  NSString *emailBody = @"";
//  [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentModalViewController:picker animated:YES];
}

// Displays an SMS composition interface inside the application. 
- (void)displaySMSComposerSheet {
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    [picker setRecipients:[NSArray arrayWithObject:phoneNo]];
    picker.messageComposeDelegate = self;
    
    [self presentModalViewController:picker animated:YES];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {   
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            [NiceAlert showWithText:@"Your email has been saved."];
            break;
        case MFMailComposeResultSent:
            [NiceAlert showWithText:@"Your email has been sent."];
            break;
        case MFMailComposeResultFailed:
            [NiceAlert showWithText:@"We failed to deliver you remail, can you try again?"];
            break;
        default:
            [NiceAlert showWithText:@"We are unable to deliver your email. Please try other means to send email to this person."];
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the 
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result {
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            [NiceAlert showWithText:@"Your SMS has been sent"];
            break;
        case MessageComposeResultFailed:
            [NiceAlert showWithText:@"We failed to deliver your SMS, can you try again?"];
            break;
        default:
            [NiceAlert showWithText:@"We are unable to deliver your SMS. Please try other means to send SMS to this person."];
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}




#pragma mark - button events

- (IBAction)onBackBtn:(id)sender {
    // [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"mh://contacts"] applyAnimated:YES]];
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"mh://nib/ContactsViewController" ] applyAnimated:YES]];
    [[TTURLRequestQueue mainQueue] cancelRequestsWithDelegate:self];
    
    shouldRefresh = YES;
}

- (IBAction)onCallBtn:(id)sender {
    NSString *cleanedString = [[phoneNo componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", escapedPhoneNumber]];
    
    NSLog(@"making phone call to: %@", phoneNo);
    if (phoneNo) {
        [[UIApplication sharedApplication] openURL:telURL];
    } else {
        [NiceAlert showWithText:@"This contact does not have number to call to."];
    }
}

- (IBAction)onSmsBtn:(id)sender {
    if (phoneNo) {
        //  The MFMessageComposeViewController class is only available in iPhone OS 4.0 or later. 
        //  So, we must verify the existence of the above class and log an error message for devices
        //      running earlier versions of the iPhone OS. Set feedbackMsg if device doesn't support 
        //      MFMessageComposeViewController API.
        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
        
        if (messageClass != nil) {          
            // Check whether the current device is configured for sending SMS messages
            if ([messageClass canSendText]) {
                [self displaySMSComposerSheet];
            }
            else {  
                [NiceAlert showWithText:@"Your device is not configured to send SMS. No SIM card?"];
            }
        }
        else {
            [NiceAlert showWithText:@"Your device is not configured to send SMS."];
        }
    } else {
        [NiceAlert showWithText:@"This contact does not have number to send a text message to."];

    }
}

- (IBAction)onEmailBtn:(id)sender {
    if (email) {

        // The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
        // So, we must verify the existence of the above class and provide a workaround for devices running 
        // earlier versions of the iPhone OS. 
        // We display an email composition interface if MFMailComposeViewController exists and the device 
        // can send emails. Display feedback message, otherwise.
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        
        if (mailClass != nil) {
            //[self displayMailComposerSheet];
            // We must always check whether the current device is configured for sending emails
            if ([mailClass canSendMail]) {
                [self displayMailComposerSheet];
            }
            else {
                [NiceAlert showWithText:@"Please configure your device mail settings first before you can send email."];
            }
        }
        else {
            [NiceAlert showWithText:@"This device cannot send email."];
        }
    } else {
        [NiceAlert showWithText:@"This contact does not have an email address to send email to."];
    }
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contactUpdated" object: nil ];    
}

- (IBAction)onShowRejoicablesBtn:(id)sender {
    [rejoicablesView setHidden:NO];
    
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
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == -1) {
        return;
    }
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

/*
 Saves status, rejoicables and comments. 
 Unselects all rejoicable buttons, refreshes comments list and sends a contactUpdated notification so the contact list updates
 */
- (IBAction)onSaveBtn:(id)sender {
    if ([self.statusSelected length] == 0) {
        [[NiceAlertView alloc] initWithText:@"You need to set a status before you can save."];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contactUpdated" object: nil ];
}

- (IBAction)onSegmentChange:(id)sender {

    [tableView reloadData];
}

- (IBAction)onPlaceHolderImageBtn:(id)sender {
    [self presentModalViewController: imagePicker animated:YES];
}

- (IBAction)onFacebookBtn:(id)sender {    
    NSString *fbProfileUrl = [NSString stringWithFormat:@"http://www.facebook.com/profile.php?id=%@", [personData objectForKey:@"fb_id"]];
    
    TTOpenURL(fbProfileUrl);
    
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator.topViewController.navigationController setNavigationBarHidden:NO];
}


@end
