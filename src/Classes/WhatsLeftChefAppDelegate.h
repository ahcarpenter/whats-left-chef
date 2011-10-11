//
//  WhatsLeftChefAppDelegate.h
//  WhatsLeftChef
//
//  Created by Drew Carpenter on 5/18/10.
//  Copyright Transylvania University 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhatsLeftChefAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;	
	NSString *dbFilePath;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet NSString *dbFilePath;

@end

