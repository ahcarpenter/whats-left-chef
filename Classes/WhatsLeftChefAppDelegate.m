//
//  WhatsLeftChefAppDelegate.m
//  WhatsLeftChef
//
//  Created by Drew Carpenter on 5/18/10.
//  Copyright Transylvania University 2010. All rights reserved.
//

#import "WhatsLeftChefAppDelegate.h"
#import "RootViewController.h"


@implementation WhatsLeftChefAppDelegate

@synthesize window, navigationController, dbFilePath;


#pragma mark -
#pragma mark Application lifecycle

NSString *DATABASE_RESOURCE_NAME = @"whatsleftchef";
NSString *DATABASE_RESOURCE_TYPE = @"db";
NSString *DATABASE_FILE_NAME = @"whatsleftchef.db";

// NSString *dbFilePath;


- (BOOL) initializeDb {
	NSLog (@"initializeDB");
	// look to see if DB is in known location (~/Documents/$DATABASE_FILE_NAME)
	//START:code.DatabaseShoppingList.findDocumentsDirectory
	NSArray *searchPaths =
	NSSearchPathForDirectoriesInDomains
	(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
	dbFilePath = [documentFolderPath stringByAppendingPathComponent:
				  DATABASE_FILE_NAME];
	NSLog(@"DB FILE PATH: %@", dbFilePath);
	//END:code.DatabaseShoppingList.findDocumentsDirectory
	[dbFilePath retain];
	//START:code.DatabaseShoppingList.copyDatabaseFileToDocuments
	
	if (! [[NSFileManager defaultManager] fileExistsAtPath: dbFilePath]) {
		// didn't find db, need to copy
		NSString *backupDbPath = [[NSBundle mainBundle]
								  pathForResource:DATABASE_RESOURCE_NAME
								  ofType:DATABASE_RESOURCE_TYPE];
		NSLog(@"DB Not Found, looking for backup");
		NSLog(@"Backup DBPath: %@", backupDbPath);
		if (backupDbPath == nil) {
			NSLog(@"couldn't find backup db to copy, bail");
			return NO;
		} else {
			NSLog(@"Found backup DB!");
			BOOL copiedBackupDb = [[NSFileManager defaultManager]
								   copyItemAtPath:backupDbPath
								   toPath:dbFilePath
								   error:nil];
			if (! copiedBackupDb) {
				// copying backup db failed, bail
				return NO;
			}
		}
	}
	NSLog(@"DB FILE PATH: %@", dbFilePath);
	return YES;
	
	//END:code.DatabaseShoppingList.copyDatabaseFileToDocuments
	NSLog (@"bottom of initializeDb");
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch    
	// copy the database from the bundle if necessary
	if (! [self initializeDb]) {
		// TODO: alert the user!
		NSLog (@"couldn't init db");
		return;
	}	

	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

