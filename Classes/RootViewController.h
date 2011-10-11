//
//  RootViewController.h
//  WhatsLeftChef
//
//  Created by Drew Carpenter on 5/18/10.
//  Copyright Transylvania University 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuestSizeViewController; 
@class FridgeViewController;
@class MealsViewController;
@class ManualFridgeItemAddViewController;

@interface RootViewController : UIViewController {
	GuestSizeViewController *guestSizeController;
	FridgeViewController *fridgeController;
	MealsViewController *mealsController;
	ManualFridgeItemAddViewController *manualFridgeItemAddController;
	NSMutableArray *listOfItems;
	NSMutableArray *copyListOfItems;
	BOOL searching;
	BOOL letUserSelectRow;
}

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

-(IBAction) goToGuestViewController:(id)sender;
-(IBAction) goToFridgeViewController:(id)sender;
-(IBAction) goToMealsViewController:(id)sender;
-(IBAction) goToManualFridgeItemAddViewController:(id)sender;

@property (nonatomic,retain) IBOutlet GuestSizeViewController *guestSizeController;
@property (nonatomic,retain) IBOutlet FridgeViewController *fridgeController;
@property (nonatomic,retain) IBOutlet MealsViewController *mealsController;
@property (nonatomic,retain) IBOutlet ManualFridgeItemAddViewController *manualFridgeItemAddController;
@end
