//
//  GuestSizeViewController.m
//  WhatsLeftChef
//
//  Created by Drew Carpenter on 5/18/10.
//  Copyright 2010 Transylvania University. All rights reserved.
//

#import "GuestSizeViewController.h"

NSString *ADD_GROUP_NAMES[] = {@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"};
@implementation GuestSizeViewController
@synthesize mealTypeSelectController, guestSizePicker;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reUsingView:(UIView *)view {
	
	UILabel *retval = (UILabel *) view;
	if(!retval) {
		retval = [[[UILabel alloc]init] autorelease];
	}
	
	retval.font = [UIFont systemFontOfSize:50];
	
	return retval;
}
// UIPickerViewDataSource implementation
-(NSInteger) pickerView: (UIPickerView*) pickerView numberOfRowsInComponent: (NSInteger) component {
	return 9;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

// UIPickerViewDelegate implementation
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return ADD_GROUP_NAMES[row];
}


-(IBAction) goToMealTypeSelectViewController:(id)sender{
	[self.navigationController pushViewController:self.mealTypeSelectController
										 animated:YES];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.mealTypeSelectController = nil;
    [super dealloc];
}


@end
