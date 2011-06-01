//
//  DiceController.m
//  FateChar
//
//  Created by Courtney Holmes on 5/15/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "DiceController.h"
#import <Security/Security.h>

@implementation DiceController

@synthesize dice0;
@synthesize dice1;
@synthesize dice2;
@synthesize dice3;
@synthesize totalLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		minus = [[UIImage imageNamed:@"minus.gif"] retain];
		zero = [[UIImage imageNamed:@"zero.gif"] retain];
		plus = [[UIImage imageNamed:@"plus.gif"] retain];
		dCount = 4;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	
}

// When we appear, always roll the dice
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	diceArray = [[NSArray arrayWithObjects:dice0, dice1, dice2, dice3, nil] retain];
    [self becomeFirstResponder];	// so we can receive shake events
	[self rollem];
}

- (void)viewDidDisappear:(BOOL)animated {
	[diceArray release];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

// When we get shook, roll the dice again
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{	
	if (motion == UIEventSubtypeMotionShake) {
		[self rollem];
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)dealloc {
    [super dealloc];
	[minus release];
	[zero release];
	[plus release];
}

/*	The basic technique here is to load up our dice views with an animated gif, and then
	let the animation run for a random period of time.
*/
- (void)rollem {
	// if we have fewer than four dice showing, the previous animation is still running
	if (dCount < 4)
		return;

	dTotal = 0;	// total score of zero
	dCount = 0; // no dice are resting

	// the label should say nothing to the user until the first die stops rolling
	UILabel* l = (UILabel*)[self.view viewWithTag:DiceTotal];
	l.text = @"";

	// create the animated image
	NSArray* animationArray = [NSArray arrayWithObjects:minus, zero, plus, nil];

	for (UIImageView* iv in diceArray) {
		iv.animationImages = animationArray;
		iv.animationDuration = 0.1; // each cycle of the animation takes 1/10 of a second
		[iv startAnimating];
		// schedule a timer for this particular die to fire at a random time from now.
		[NSTimer scheduledTimerWithTimeInterval:[self randomIntervalMinimum:0.5 maximum:1.5]
										 target:self
									   selector:@selector(stopDice:)
									   userInfo:iv
										repeats:NO];
	}
}

/*	When we stop the die, we select a final value at random and display that particular image.
	Then we add up the total so far and change the label for the user.
*/
- (void)stopDice:(NSTimer*)timer {
	UIImageView* iv = (UIImageView*) [timer userInfo];
	dCount++;  // keep track of how many dice have come to rest
	
	[iv stopAnimating];

	NSUInteger rez = [self randomIntegerMinimum:-1 maximum:1];
	switch (rez) {
		case -1:
			iv.image = minus;
			dTotal -= 1;
			break;
		case 0:
			iv.image = zero;
			break;
		case 1:
			iv.image = plus;
			dTotal += 1;
			break;
		default:
			NSLog(@"Invalid roll: %d", rez);
			break;
	}
	UILabel* l = (UILabel*)[self.view viewWithTag:DiceTotal];
	l.text = [NSString stringWithFormat:@"%+d", dTotal];
}

- (NSTimeInterval)randomIntervalMinimum:(NSTimeInterval)min maximum:(NSTimeInterval)max {
	// we divide the allotted time into one thousand slices, then pick a number between 1 and 1000
	NSTimeInterval slice = (max - min) / 1000;
	NSUInteger sliceCount = [self randomIntegerMinimum:0 maximum:999];
	return min + (sliceCount * slice);
}

/*	I'm a stickler for random number generation, so I pulled in the Security Framework just for
	this little routine.  The standard C rand() is almost never good enough ... especially when
	my character's life is on the line!
*/
- (NSUInteger)randomIntegerMinimum:(NSUInteger)min maximum:(NSUInteger)max {
	NSUInteger raw;
	int result;
	
	result = SecRandomCopyBytes (kSecRandomDefault, sizeof(raw), (uint8_t*) &raw);
	if (!result) {
		raw = min + (raw % (max-min+1));
	} else {
		raw = min;
	}

	return raw;
}

@end
