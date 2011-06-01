//
//  DiceController.h
//  FateChar
//
//  Created by Courtney Holmes on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	DiceView0 = 100,
	DiceView1 = 101,
	DiceView2 = 102,
	DiceView3 = 103,
	DiceTotal = 200,
} DiceControllerViewTag;

@interface DiceController : UIViewController {
	/*	Actually, it is possible to have a single array outlet hold multiple views.
		If I ever need more of these, I'll fix it then.
	*/
	UIImageView* dice0;
	UIImageView* dice1;
	UIImageView* dice2;
	UIImageView* dice3;
	
	NSArray* diceArray;
	
	// our label for displaying the total to the user
	UILabel* totalLabel;
	
	// There are three images for the dice: one each for -1, zero, and +1
	UIImage* minus;
	UIImage* zero;
	UIImage* plus;
	
	// How many dice are still?
	NSUInteger dCount;
	
	// The total score
	NSUInteger dTotal;
}

@property (retain) IBOutlet UIImageView* dice0;
@property (retain) IBOutlet UIImageView* dice1;
@property (retain) IBOutlet UIImageView* dice2;
@property (retain) IBOutlet UIImageView* dice3;
@property (retain) IBOutlet UILabel* totalLabel;

- (void)rollem;
- (NSTimeInterval)randomIntervalMinimum:(NSTimeInterval)min maximum:(NSTimeInterval)max;
- (NSUInteger)randomIntegerMinimum:(NSUInteger)min maximum:(NSUInteger)max;

@end
