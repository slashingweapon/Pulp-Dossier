//
//  TrackViewController.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/10/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "TrackViewController.h"


@implementation TrackViewController

@synthesize track;
@synthesize maxLabel;
@synthesize boxFields;
@synthesize consequenceFields;
@synthesize doneBtn;
@synthesize cancelBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		track = nil;
		maximumValue = 5;
		bitfieldValue = 0;
    }

    return self;
}

- (void)dealloc {
    [super dealloc];
	[track release];
	[maxLabel release];
	[boxFields release];
	[consequenceFields release];
	[doneBtn release];
	[cancelBtn release];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	UIScrollView *sv = (UIScrollView*) self.view;
	CGRect rect = sv.frame;
	rect.size.height += 400;
	sv.contentSize = rect.size;
}

/*	Set up our UI state */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	maximumValue = [track.maximum integerValue];
	bitfieldValue = [track.track integerValue];
	maxLabel.text = [@"Maximum: " stringByAppendingFormat:@"%d", maximumValue];
	NSInteger idx;
	UIButton *btn;
	UILabel *lbl;
	NSString *oneConsequence;
	NSString *checked;

	self.consequenceFields = [consequenceFields sortedArrayUsingFunction:originSort context:nil];
	self.boxFields = [boxFields sortedArrayUsingFunction:originSort context:nil];
	
	for (idx=0; idx<[boxFields count] && idx<maximumValue; idx++) {
		btn = [boxFields objectAtIndex:idx];
		btn.enabled = YES;
		btn.hidden = NO;
		checked = (bitfieldValue & (1 << idx)) ? CAttributeTrackChecked : CAttributeTrackUnchecked;
		[btn setTitle:checked forState:UIControlStateNormal];
	}
	
	for (; idx<[boxFields count]; idx++) {
		btn = [boxFields objectAtIndex:idx];
		btn.enabled = NO;
		btn.hidden = YES;
	}

	for (idx = 0; idx<[consequenceFields count] && idx<[track.consequences count]; idx++) {
		lbl = [consequenceFields objectAtIndex:idx];
		oneConsequence = [track.consequences objectAtIndex:idx];
		lbl.text = oneConsequence;
	}
	
	for (; idx<[consequenceFields count]; idx++) {
		lbl = [consequenceFields objectAtIndex:idx];
		lbl.text = @"";
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(scrollUp:)
												 name:UIKeyboardDidShowNotification object:nil];
	
	
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction) toggleBox: (id)sender {
	UIButton *btn = sender;
	NSString *currentValue = btn.currentTitle;
	NSString *newValue = [currentValue isEqualToString:CAttributeTrackChecked] 
		? CAttributeTrackUnchecked 
		: CAttributeTrackChecked ;
	[btn setTitle:newValue forState:UIControlStateNormal];
}

- (IBAction)changeMax:(id)sender {
	UISegmentedControl *seg = sender;
	UIButton *btn;
	
	if (seg.selectedSegmentIndex == 0 && maximumValue > 1) {
		// The user wants to decrease the number of boxes in the track, and
		// is not trying to go below 1.
		maximumValue--;
		btn = [boxFields objectAtIndex:maximumValue];
		btn.enabled = NO;
		btn.hidden = YES;
		[btn setTitle:CAttributeTrackUnchecked forState:UIControlStateNormal];
	} else if (seg.selectedSegmentIndex == 1 && maximumValue < [boxFields count] ) {
		btn = [boxFields objectAtIndex:maximumValue];
		btn.enabled = YES;
		btn.hidden = NO;
		[btn setTitle:CAttributeTrackUnchecked forState:UIControlStateNormal];
		maximumValue++;
	}
}

/*	Use our data to set a new state for our source track object */
- (IBAction)done:(id)sender {
	NSInteger idx;
	UILabel *lbl;
	
	[track.consequences removeAllObjects];
	
	for (idx=0; idx<[consequenceFields count]; idx++) {
		lbl = [consequenceFields objectAtIndex:idx];
		if (! [lbl.text isEqualToString:@""])
			[track.consequences addObject:lbl.text];
	}
	track.maximum = [NSNumber numberWithInteger:maximumValue];
	
	bitfieldValue = 0;
	for (idx=0; idx<maximumValue && idx<[boxFields count]; idx++) {
		UIButton *btn = [boxFields objectAtIndex:idx];
		NSString *junk = btn.titleLabel.text;
		if ([junk isEqualToString:CAttributeTrackChecked])
			bitfieldValue |= (1 << idx);
	}

	track.track = [NSNumber numberWithInteger:bitfieldValue];
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)putAwayKeyboard:(id)sender {
	[sender resignFirstResponder];
}

- (IBAction)scrollUp:(NSNotification*)notification {
	UITextField *tf = [self.consequenceFields objectAtIndex:0];
	UIScrollView *sv = (UIScrollView*) self.view;
	
	CGPoint newOffset = CGPointMake(0, tf.frame.origin.y-40);
	if (tf && sv)
		[sv setContentOffset:newOffset animated:YES];
//		[sv scrollRectToVisible:tf.frame animated:YES];
}


@end

NSInteger originSort(id btn1, id btn2, void *context)
{
    CGPoint o1 = ((UIButton*)btn1).frame.origin;
	CGPoint o2 = ((UIButton*)btn2).frame.origin;

	if ((o1.y < o2.y) || (o1.y == o2.y && o1.x < o2.x))
        return NSOrderedAscending;
    else if ((o1.y > o2.y) || (o1.y == o2.y && o1.x > o2.x))
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}
