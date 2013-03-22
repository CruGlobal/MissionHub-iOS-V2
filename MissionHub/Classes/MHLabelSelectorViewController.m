//
//  MHLabelSelectorViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 2/19/13.
//
//

#import "MHLabelSelectorViewController.h"

@interface MHLabelSelectorViewController ()

@end

@implementation MHLabelSelectorViewController

@synthesize delegate;
@synthesize allRoles, selectedRoles, originallySelectedRoles;
@synthesize applyButton;
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
		self.allRoles		= [[MHRolesCollection alloc] initWithArray:[[NSMutableArray alloc] init]];
		self.selectedRoles	= [[MHRolesCollection alloc] initWithArray:[[NSMutableArray alloc] init]];
		
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
	
	[self.tableView reloadData];
	
}

-(void)updateRoles:(MHRolesCollection *)roles {
	
	self.allRoles			= roles;
	
	[self.tableView reloadData];
	
}

-(void)updateSelectedRoles:(MHRolesCollection *)selected {
	
	self.selectedRoles				= selected;
	self.originallySelectedRoles	= [selected copy];
	
	[self.tableView reloadData];
	
}

- (IBAction)onApply:(id)sender {
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(addLabels:removeLabels:)]) {
	
		NSMutableArray *rolesToAdd		= [[NSMutableArray alloc] init];
		NSMutableArray *rolesToRemove	= [[NSMutableArray alloc] init];
		
		for (id role in self.allRoles.rolesArray) {
			
			if ([self.selectedRoles hasRole:role] && ![self.originallySelectedRoles hasRole:role]) {
				
				[rolesToAdd addObject:[role objectForKey:@"id"]];
				
			}
			
			if (![self.selectedRoles hasRole:role] && [self.originallySelectedRoles hasRole:role]) {
				
				[rolesToRemove addObject:[role objectForKey:@"id"]];
				
			}
			
		}
		
		[self.delegate addLabels:rolesToAdd removeLabels:rolesToRemove];
		
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
    // Return the number of rows in the section.
    return [self.allRoles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectorCell";
    MHLabelSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[MHLabelSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	id role = [self.allRoles roleForIndexPath:indexPath];
	NSString	*name			= [role objectForKey:@"name"];
	
	if (![name isKindOfClass:[NSString class]]) {
		name = @"";
	}
    
	cell.delegate				= self;
	cell.role					= role;
	cell.titleTextField.text	= name;
	[cell setChecked:[self.selectedRoles hasRole:role]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHLabelSelectorCell *cell	= (MHLabelSelectorCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	id role						= [self.allRoles roleForIndexPath:indexPath];
	
	[self roleTableViewCell:cell didTapIconWithRoleItem:role];
	
}

#pragma mark - MHRoleSelectionCell delegate

-(void)roleTableViewCell:(MHLabelSelectorCell *)cell didTapIconWithRoleItem:(MHLabelSelectorCell *)roleItem {
	
	if ([self.selectedRoles hasRole:roleItem]) {
		
		[self.selectedRoles removeRole:roleItem];
		[cell setChecked:NO];
		
	} else {
		
		[self.selectedRoles addRole:roleItem];
		[cell setChecked:YES];
		
	}
	
	//[self.tableView reloadData];
	
}


@end
