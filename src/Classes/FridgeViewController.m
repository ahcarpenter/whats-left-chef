//
//  FridgeViewController.m
//  WhatsLeftChef
//
//  Created by Drew Carpenter on 5/18/10.
//  Copyright 2010 Transylvania University. All rights reserved.
//

#import "FridgeViewController.h"
#include <sqlite3.h>
#import "WhatsLeftChefAppDelegate.h"


@implementation FridgeViewController
@synthesize nibLoadedTableCell, foodItem;

// keys for key-value pair NSDicts in the shoppingListItems
NSString *FOOD_ID_KEY = @"food_id";
NSString *FOOD_NAME_KEY = @"food_name";
NSString *IMAGE_PATH_KEY = @"image_path";
NSString *VOLUME_AMOUNT_KEY = @"volume_amount";
NSString *VOLUME_UNIT_KEY = @"volume_unit";
NSString *VOLUME_ID_KEY = @"volume_id";


NSMutableArray *fridgeItems;

#pragma mark -
#pragma mark Initialization

-(IBAction)deleteFridgeItem:(id)sender:(NSString *) food_name
{
	NSLog (@"food_name: %@", food_name);
	
	sqlite3 *db;
	int dbrc; // database return code
	WhatsLeftChefAppDelegate *appDelegate = (WhatsLeftChefAppDelegate*) [UIApplication sharedApplication].delegate;
	const char* dbFilePathUTF8 = [appDelegate.dbFilePath UTF8String];
	//const char* dbFilePathUTF8 = [shoppingDB UTF8String];
	dbrc = sqlite3_open (dbFilePathUTF8, &db);
	NSMutableString *query = [[NSMutableString alloc] init];
	[query appendString:@"delete from fridge where food_name = '"];
	[query appendString:food_name];
	[query appendString:@"'"];
	if (dbrc) {
		NSLog (@"couldn't open db:");
		return;
	}
	NSLog (@"opened db");
	NSString *query1 = [[NSString alloc] init];
	query1 = query;
	sqlite3_exec(db,query1, NULL, NULL, NULL);
	NSLog(@"query: %@", query1);
	//sqlite3_finalize (dbps);
	sqlite3_close(db);
}

/* Loads all rows from database into shoppingListItems array
 */
- (void) loadDataFromDb {
	NSLog (@"loadDataFromDb");
	
	sqlite3 *db;
	int dbrc; // database return code
	WhatsLeftChefAppDelegate *appDelegate = (WhatsLeftChefAppDelegate*) [UIApplication sharedApplication].delegate;
	const char* dbFilePathUTF8 = [appDelegate.dbFilePath UTF8String];
	//const char* dbFilePathUTF8 = [shoppingDB UTF8String];
	dbrc = sqlite3_open (dbFilePathUTF8, &db);
	if (dbrc) {
		NSLog (@"couldn't open db:");
		return;
	}
	NSLog (@"opened db");
	
	// select stuff
	sqlite3_stmt *dbps; // database prepared statement
	//START:code.DatabaseShoppingList.readFromDatabaseQueryStatement
	NSString *queryStatementNS =
	@"select fridge.food_id, fridge.food_name, fridge.volume_id, fridge.image_id, volume.volume_amount, volume.volume_unit, image.image_path FROM fridge, volume, image WHERE fridge.volume_id = volume.volume_id AND fridge.image_id  = image.image_id";
	//END:code.DatabaseShoppingList.readFromDatabaseQueryStatement
	const char *queryStatement = [queryStatementNS UTF8String];
	dbrc = sqlite3_prepare_v2 (db, queryStatement, -1, &dbps, NULL);
	NSLog (@"prepared statement");
	
	// at this point, clear out any existing table model array and prepare new one
	[fridgeItems release];
	fridgeItems = [[NSMutableArray alloc] initWithCapacity: 100]; // arbitrary capacity
	
	// repeatedly execute the prepared statement until we're out of results
	//START:code.DatabaseShoppingList.readFromDatabaseResults
	while ((dbrc = sqlite3_step (dbps)) == SQLITE_ROW) {
		int food_idValueS = sqlite3_column_int(dbps, 0);
		NSNumber *food_idValue = [[NSNumber alloc]
											initWithInt: food_idValueS];
		NSString *food_nameValue = [[NSString alloc]
											 initWithUTF8String: (char*) sqlite3_column_text (dbps, 1)];
		int volume_idValueS = sqlite3_column_int(dbps, 2);
		NSNumber *volume_idValue = [[NSNumber alloc]
										initWithInt: volume_idValueS];
		int volume_amountValueS = sqlite3_column_int(dbps, 4);
		NSNumber *volume_amountValue = [[NSNumber alloc]
								  initWithInt: volume_amountValueS];
		NSString *volume_unitValue = [[NSString alloc]
									initWithUTF8String: (char*) sqlite3_column_text (dbps, 5)];
		NSString *image_pathValue = [[NSString alloc]
									  initWithUTF8String: (char*) sqlite3_column_text (dbps, 6)];
		NSLog(@"Image Path: %@", image_pathValue);
		NSMutableDictionary *fridgeDict =
		[[NSMutableDictionary alloc] initWithCapacity: 6];
		[fridgeDict setObject: food_idValue forKey: FOOD_ID_KEY];
		[fridgeDict setObject: food_nameValue forKey: FOOD_NAME_KEY];
		[fridgeDict setObject: volume_amountValue forKey: VOLUME_AMOUNT_KEY];
		[fridgeDict setObject: volume_unitValue forKey: VOLUME_UNIT_KEY];
		[fridgeDict setObject: image_pathValue forKey: IMAGE_PATH_KEY];
		[fridgeDict setObject: volume_idValue forKey: VOLUME_ID_KEY];
		[fridgeItems addObject: fridgeDict];
		[food_idValue release];
		[food_nameValue release];
		[volume_amountValue  release];
		[volume_unitValue  release];
		[image_pathValue release];
		[volume_idValue release];
		[fridgeDict release];
	}
	//END:code.DatabaseShoppingList.readFromDatabaseResults
	
	// done with the db.  finalize the statement and close
	sqlite3_finalize (dbps);
	sqlite3_close(db);
}

- (void)viewWillAppear:(BOOL)animated {
	[self loadDataFromDb];
	[super viewWillAppear:animated];
	[self.tableView reloadData]; 
}

#pragma mark -
#pragma mark View lifecycle

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [fridgeItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (myCell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"FridgeItemTableViewCell" owner:self options:NULL];
		myCell = nibLoadedTableCell;
	} 
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	//START:code.DatabaseShoppingList.setcellcontents
	UILabel *food_nameLabel = (UILabel*) [myCell viewWithTag:1];
	UILabel *volume_amountLabel = (UILabel*) [myCell viewWithTag:3];
	UILabel *volume_unitLabel = (UILabel*) [myCell viewWithTag:4];
	UILabel *volume_idLabel = (UILabel*) [myCell viewWithTag:5];
	UIImageView *imageView = (UIImageView *) [myCell viewWithTag:2];
	UIButton *deleteButton = (UIButton *) [myCell viewWithTag:6];
		NSDictionary *rowVals =
		(NSDictionary*) [fridgeItems objectAtIndex: indexPath.row];
	
	NSString *food_name1 = (NSString*) [rowVals objectForKey: FOOD_NAME_KEY];
	//[deleteButton removeTarget:self action:@selector(deleteFridgeItem:food_name1:) forControlEvents:UIControlEventTouchUpInside];
	//[deleteButton addTarget: self action: @selector(deleteFridgeItem:food_name1:) forControlEvents: UIControlEventTouchUpInside];
	 
	food_nameLabel.text = food_name1;
	NSNumber *volume_id = (NSNumber*) [rowVals objectForKey: VOLUME_ID_KEY];
	volume_idLabel.text =  [formatter stringFromNumber: volume_id];
	NSNumber *volume_amount = (NSNumber*) [rowVals objectForKey: VOLUME_AMOUNT_KEY];
	volume_amountLabel.text =  [formatter stringFromNumber: volume_amount];
	NSString *volume_unit = (NSString*) [rowVals objectForKey: VOLUME_UNIT_KEY];
	volume_unitLabel.text = volume_unit;	
	NSString *imagePath = (NSString *) [rowVals objectForKey:IMAGE_PATH_KEY];
	NSLog(@"IMAGE PATH: %@", imagePath);
	imageView.image = [UIImage imageNamed:imagePath];
	//END:code.DatabaseShoppingList.setcellcontents
	[formatter release];
	
	return myCell;
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) buttonPushed:(id)sender
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	self.editButtonItem.title = @"Home";
	self.editButtonItem.target = self;
	self.editButtonItem.action = @selector(buttonPushed:);
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[foodItem release];
	[nibLoadedTableCell release];
    [super dealloc];
}


@end
