//
//  MealsViewController.h
//  WhatsLeftChef
//
//  Created by Drew Carpenter on 5/18/10.
//  Copyright 2010 Transylvania University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealDetailViewController.h"


@interface MealsViewController : UITableViewController {
	UITableViewCell *nibLoadedTableCell;
	MealDetailViewController *mealDetailViewController;
}
- (void) buttonPushed:(id)sender;
@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedTableCell;
@property (nonatomic, retain) IBOutlet MealDetailViewController *mealDetailViewController;
@end
