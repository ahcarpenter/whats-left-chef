//
//  Food.m
//  WhatsLeftChef
//
//  Created by Drew Carpenter on 5/24/10.
//  Copyright 2010 Transylvania University. All rights reserved.
//

#import "Food.h"


@implementation Food
@synthesize food_name;

- (void) dealloc { // <label id="code.Movie.dealloc"/>
	self.food_name = nil;
	[super dealloc];
}
@end
