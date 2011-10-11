//
//  GuestSizeViewController.h
//  WhatsLeftChef
//
//  Created by Drew Carpenter on 5/18/10.
//  Copyright 2010 Transylvania University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MealTypeSelectViewController;


@interface GuestSizeViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	MealTypeSelectViewController *mealTypeSelectController;
	UIPickerView *guestSizePicker;

}
-(IBAction) goToMealTypeSelectViewController:(id)sender;
- (void) buttonPushed:(id)sender;
@property (retain, nonatomic) IBOutlet MealTypeSelectViewController *mealTypeSelectController;
@property (nonatomic, retain) IBOutlet UIPickerView *guestSizePicker;

@end
