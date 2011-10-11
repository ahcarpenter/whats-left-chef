//
//  MealsViewController.m
//  WhatsLeftChef
//
//  Created by Drew Carpenter on 5/18/10.
//  Copyright 2010 Transylvania University. All rights reserved.
//

#import "MealsViewController.h"
#include <sqlite3.h>
#import "WhatsLeftChefAppDelegate.h"

@implementation MealsViewController
@synthesize nibLoadedTableCell, mealDetailViewController;

// keys for key-value pair NSDicts in the shoppingListItems
NSString *PRIMARY_ID_KEY = @"recipe_id";
NSString *RECIPE_NAME_KEY = @"recipe_name";
NSString *RECIPE_NOTE_KEY = @"recipe_note";
NSString *RECIPE_DESCRIPTION_KEY = @"recipe_description";
NSString *RECIPE_FAVORITE_KEY = @"recipe_favorite";
NSString *RECIPE_RATING_KEY = @"recipe_rating";
NSString *IMAGE_ID_KEY = @"image_id";
NSString *RECIPE_ACTIVETIME_KEY = @"recipe_activeTime";
NSString *RECIPE_TOTALTIME_KEY = @"recipe_totalTime";
NSString *INGREDIENTLIST_ID_KEY = @"ingredientList_id";
NSString *IMAGE_PATH = @"image_path";

NSMutableArray *recipeItems;

#pragma mark -
#pragma mark Initialization

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
	sqlite3_exec(db, "DROP VIEW foodvolume", NULL, NULL, NULL);
	sqlite3_exec(db,"CREATE VIEW foodvolume AS select fridge.food_type, volume.volume_amount from fridge, volume where volume.volume_id = fridge.volume_id", NULL, NULL, NULL);
	sqlite3_exec(db, "DROP VIEW recipeingredient", NULL, NULL, NULL);
	sqlite3_exec(db,"CREATE VIEW recipeingredient AS select ingredient.ingredient_type, volume.volume_amount, ingredient.recipe_id from ingredient, volume where volume.volume_id = ingredient.volume_id", NULL, NULL, NULL);
	sqlite3_exec(db, "DROP VIEW fv_ri", NULL, NULL, NULL);
	sqlite3_exec(db,"CREATE VIEW fv_ri AS select recipeingredient.recipe_id from recipeingredient, foodvolume where foodvolume.food_type = recipeingredient.ingredient_type and foodvolume.volume_amount >= recipeingredient.volume_amount", NULL, NULL, NULL);
	sqlite3_exec(db, "DROP VIEW fv_ri_count", NULL, NULL, NULL);
	sqlite3_exec(db,"CREATE VIEW fv_ri_count AS SELECT recipe_id, count(recipe_id) as ingredient_count FROM fv_ri GROUP BY recipe_id", NULL, NULL, NULL);
	sqlite3_exec(db, "DROP VIEW ri_count", NULL, NULL, NULL);
	sqlite3_exec(db,"CREATE VIEW ri_count AS SELECT recipe_id, count(recipe_id) as ingredient_count FROM ingredient GROUP BY recipe_id", NULL, NULL, NULL);
	sqlite3_exec(db, "DROP VIEW match", NULL, NULL, NULL);
	sqlite3_exec(db,"CREATE VIEW match AS select fv_ri_count.recipe_id from fv_ri_count, ri_count where ri_count.ingredient_count = fv_ri_count.ingredient_count", NULL, NULL, NULL);
	NSString *queryStatementNS =
	@"select DISTINCT recipe.recipe_name, recipe.recipe_description, recipe.recipe_activeTime, recipe.recipe_totalTime, recipe.image_id, image.image_path FROM recipe, match, image WHERE recipe.image_id = image.image_id and recipe.recipe_id = match.recipe_id";
	//END:code.DatabaseShoppingList.readFromDatabaseQueryStatement
	const char *queryStatement = [queryStatementNS UTF8String];
	dbrc = sqlite3_prepare_v2 (db, queryStatement, -1, &dbps, NULL);
	NSLog (@"prepared statement");
	
	// at this point, clear out any existing table model array and prepare new one
	[recipeItems release];
	recipeItems = [[NSMutableArray alloc] initWithCapacity: 100]; // arbitrary capacity
	
	// repeatedly execute the prepared statement until we're out of results
	//START:code.DatabaseShoppingList.readFromDatabaseResults
	
	while ((dbrc = sqlite3_step (dbps)) == SQLITE_ROW) {
		NSString *recipe_nameValue = [[NSString alloc]
											 initWithUTF8String: (char*) sqlite3_column_text (dbps, 0)];
		NSLog(@"recipe_nameValue %@", recipe_nameValue);
		
		NSString *recipe_descriptionValue = [[NSString alloc]
									  initWithUTF8String: (char*) sqlite3_column_text (dbps, 1)];
		NSLog(@"desc %@", recipe_descriptionValue);
		
		NSString *image_path = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(dbps, 5)];
		NSLog(@"image_path %@", image_path);
		
		int recipe_activeTimeValueS = sqlite3_column_int(dbps, 2);
		NSNumber *recipe_activeTimeValue = [[NSNumber alloc]
										  initWithInt: recipe_activeTimeValueS];
		int recipe_totalTimeValueS = sqlite3_column_int(dbps, 3);
		NSNumber *recipe_totalTimeValue = [[NSNumber alloc]
										  initWithInt: recipe_totalTimeValueS];
		
		NSMutableDictionary *rowDict =
		[[NSMutableDictionary alloc] initWithCapacity: 5];
		[rowDict setObject: recipe_nameValue forKey: RECIPE_NAME_KEY];
		[rowDict setObject: recipe_descriptionValue forKey: RECIPE_DESCRIPTION_KEY];
		[rowDict setObject: recipe_activeTimeValue forKey: RECIPE_ACTIVETIME_KEY];
		[rowDict setObject: recipe_totalTimeValue forKey: RECIPE_TOTALTIME_KEY];
		[rowDict setObject: image_path forKey: IMAGE_PATH];
		[recipeItems addObject: rowDict];
		[recipe_nameValue release];
		[recipe_descriptionValue release];
		[recipe_activeTimeValue  release];
		[recipe_totalTimeValue  release];
		[image_path release];
		[rowDict release];
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
    return [recipeItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (myCell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"RecipeListTableViewCell" owner:self options:NULL];
		myCell = nibLoadedTableCell;
	} 
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	//START:code.DatabaseShoppingList.setcellcontents
	UILabel *recipe_nameLabel = (UILabel*) [myCell viewWithTag:5];
	UILabel *recipe_activeTimeLabel = (UILabel*) [myCell viewWithTag:1];
	UILabel *recipe_totalTimeLabel = (UILabel*) [myCell viewWithTag:2];
	UILabel *recipe_descriptionLabel = (UILabel*) [myCell viewWithTag:4];
	UIImageView *imageView = (UIImageView *) [myCell viewWithTag:6];
	NSDictionary *rowVals =
	(NSDictionary*) [recipeItems objectAtIndex: indexPath.row];
	NSString *recipe_name = (NSString*) [rowVals objectForKey: RECIPE_NAME_KEY];
	recipe_nameLabel.text = recipe_name;
	NSNumber *recipe_activeTime = (NSNumber*) [rowVals objectForKey: RECIPE_ACTIVETIME_KEY];
	recipe_activeTimeLabel.text =  [formatter stringFromNumber: recipe_activeTime];
	NSNumber *recipe_totalTime = (NSNumber*) [rowVals objectForKey: RECIPE_TOTALTIME_KEY];
	recipe_totalTimeLabel.text =  [formatter stringFromNumber: recipe_totalTime];
	NSString *recipe_description = (NSString*) [rowVals objectForKey: RECIPE_DESCRIPTION_KEY];
	recipe_descriptionLabel.text = recipe_description;	
	NSString *imagePath = (NSString *) [rowVals objectForKey:IMAGE_PATH];
	imageView.image = [UIImage imageNamed:imagePath];
	//NSLog(@"MEALS IMAGE PATH");
	
	//END:code.DatabaseShoppingList.setcellcontents
	[formatter release];
	 
	return myCell;
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.navigationController pushViewController:self.mealDetailViewController
										 animated:YES];
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
	self.mealDetailViewController = nil;
	[nibLoadedTableCell release];
    [super dealloc];
}


@end

