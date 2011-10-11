//
//  ManualFridgeItemAddViewController.h
//  WhatsLeftChef
//
//  Created by Drew Carpenter on 5/18/10.
//  Copyright 2010 Transylvania University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ManualFridgeItemAddViewController : UIViewController {
	UITextField *name;
	UITextField *volume;
	UITextField *type;
	UIImage *image;
}

- (void) buttonPushed:(id)sender;

@end
