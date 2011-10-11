//
//  FridgeViewController.h
//  WhatsLeftChef
//
//  Created by Drew Carpenter on 5/18/10.
//  Copyright 2010 Transylvania University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Food;

@interface FridgeViewController : UITableViewController {
	UITableViewCell *nibLoadedTableCell;
	Food *foodItem;
}
- (void) buttonPushed:(id)sender;
@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedTableCell;
@property (nonatomic, retain) Food *foodItem;
@end
