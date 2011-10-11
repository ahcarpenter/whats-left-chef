//
//  RootViewController.m
//  WhatsLeftChef
//
//  Created by Drew Carpenter on 5/18/10.
//  Copyright Transylvania University 2010. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController
@synthesize guestSizeController;
@synthesize fridgeController;
@synthesize manualFridgeItemAddController;
@synthesize mealsController;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBar.tintColor = [UIColor 
														 colorWithRed:.95 green:.65 blue:.23 alpha:1.0]; 
	self.searchDisplayController.searchBar.tintColor = [UIColor 
														colorWithRed:.95 green:.65 blue:.23 alpha:1.0];  
	listOfItems = [[NSMutableArray alloc] init];
	
	NSArray *countriesToLiveInArray = [NSArray arrayWithObjects:@"Iceland", @"Greenland", @"Switzerland", @"Norway", @"New Zealand", @"Greece", @"Rome", @"Ireland", nil];
	NSDictionary *countriesToLiveInDict = [NSDictionary dictionaryWithObject:countriesToLiveInArray forKey:@"Countries"];
	
	NSArray *countriesLivedInArray = [NSArray arrayWithObjects:@"India", @"U.S.A", nil];
	NSDictionary *countriesLivedInDict = [NSDictionary dictionaryWithObject:countriesLivedInArray forKey:@"Countries"];
	
	[listOfItems addObject:countriesToLiveInDict];
	[listOfItems addObject:countriesLivedInDict];
	
	//Initialize the copy array.
	copyListOfItems = [[NSMutableArray alloc] init];
	
	self.searchDisplayController.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	
	searching = NO;
	letUserSelectRow = YES;
}


- (void) searchTableView{
}
- (void) doneSearching_Clicked:(id)sender{
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	searching = YES;
	letUserSelectRow = NO;
	//self.tableView.scrollEnabled = NO;
	
	//Add the done button.
	self.navigationController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
																				  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																				target:self action:@selector(doneSearching_Clicked:)] autorelease];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

-(IBAction) goToGuestViewController:(id)sender{
	[self.navigationController pushViewController:self.guestSizeController
										 animated:YES];
}

-(IBAction) goToFridgeViewController:(id)sender{
	[self.navigationController pushViewController:self.fridgeController
										 animated:YES];
}

-(IBAction) goToMealsViewController:(id)sender{
	[self.navigationController pushViewController:self.mealsController
										 animated:YES];
}

-(IBAction) goToManualFridgeItemAddViewController:(id)sender{
	[self.navigationController pushViewController:self.manualFridgeItemAddController
										 animated:YES];
}


#pragma mark -
#pragma mark Table view data source
/*
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.

    return cell;
}

*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 
}
*/

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	self.fridgeController = nil;
	self.mealsController = nil;
	self.manualFridgeItemAddController = nil;
	self.guestSizeController = nil;
    [super dealloc];
}


@end

