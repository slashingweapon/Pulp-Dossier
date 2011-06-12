//
//  IntegerCell.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/12/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "IntegerCell.h"


@implementation IntegerCell

@synthesize minValue;
@synthesize maxValue;
@synthesize formatSelector;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		NSArray *segItems = [NSArray arrayWithObjects:@"  -  ", @"  +  ", nil];
		currentValue = 0;
		minValue = 0;
		maxValue = 100;
        segV = [[UISegmentedControl alloc] initWithItems:segItems];
		segV.momentary = YES;
		segV.segmentedControlStyle = UISegmentedControlStyleBar;
		[segV addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
		// [self.contentView addSubview:segV];
		self.editingAccessoryView = segV;
		
		self.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}

- (void)dealloc {
	[super dealloc];
	[segV release];
}

/*	There is an interesting possibility here.  If someone sets a flag to "always allow editing",
 *	then maybe we can test for it in this method, and ensure that the editing accessory is always
 *	available.
 */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSNumber *newValue = [change valueForKey:NSKeyValueChangeNewKey];
	NSString *newText = nil;
	
	if ([newValue isKindOfClass:[NSNumber class]]) {
		currentValue = [newValue integerValue];
		if (formatSelector && dataTarget && [dataTarget respondsToSelector:formatSelector])
			newText = [dataTarget performSelector:formatSelector];
		if (newText == nil)
			newText = [NSString stringWithFormat:@"%d", currentValue];
		self.detailTextLabel.text = newText;
		[self setNeedsLayout];
	}
}

- (IBAction) changeValue:(id)sender {
	NSNumber *num = nil;
	
	if (sender == segV) {
		if (segV.selectedSegmentIndex == 0 && currentValue > minValue)
			num = [NSNumber numberWithInteger:currentValue-1];
		else if (segV.selectedSegmentIndex == 1 && currentValue < maxValue)
			num = [NSNumber numberWithInteger:currentValue+1];

		if (num != nil)
			[dataTarget setValue:num forKey:dataKey];
	}
}

@end
