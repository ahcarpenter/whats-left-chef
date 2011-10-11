//
//  MealTypeSelectViewController.h
//  WhatsLeftChef
//
//  Created by Drew Carpenter on 5/18/10.
//  Copyright 2010 Transylvania University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MealsViewController;

@interface MealTypeSelectViewController : UIViewController {
	MealsViewController *mealsController;
}
-(IBAction) goToMealsViewController:(id)sender;
- (void) buttonPushed:(id)sender;
@property (nonatomic,retain) IBOutlet MealsViewController *mealsController;

@end
