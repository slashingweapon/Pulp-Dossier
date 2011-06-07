//
//  CRLadderView.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/4/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CRLadderView.h"


@implementation CRLadderView


- (id)initWithFrame:(CGRect)frame {
    font = [[UIFont fontWithName:@"American Typewriter" size:17] retain];
	
    self = [super initWithFrame:frame];
    if (self) {
		ladder = [[NSArray arrayWithObjects:
				  @"Legendary", 
				  @"Epic", 
				  @"Fantastic",
				  @"Superb",
				  @"Great",
				  @"Good",
				  @"Fair",
				  @"Average",
				  @"Mediocre",
				  @"Poor",
				  @"Terrible",
				  nil] retain];
		frame.origin.x = 0.0;
		frame.origin.y = 0.0;
		picker = [[UIPickerView alloc] initWithFrame:frame];
		picker.dataSource = self;
		picker.delegate = self;
		picker.showsSelectionIndicator = YES;
		[picker selectRow:8 inComponent:0 animated:NO];
		[self addSubview:picker];
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
	[picker release];
	[ladder release];
	[font release];
}

- (void)setParams:(NSDictionary*)dict withDataSource:(id)source {
	[super setParams:dict withDataSource:source];
	
	NSString *text = [self getSourceString];
	if (text) {
		NSInteger index = [ladder indexOfObjectIdenticalTo:text];
		if (index != NSNotFound)
			[picker selectRow:index inComponent:0 animated:YES];
	}
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [ladder count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return font.lineHeight;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	CGFloat widest = 0.0;
	
	for (NSString *oneLabel in ladder) {
		CGSize oneSize = [oneLabel sizeWithFont:font];
		if (oneSize.width > widest)
			widest = oneSize.width;
	}
	
	return widest + 10.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)oldView {
	UILabel *label = (UILabel*)oldView;
	
	if (oldView == nil) {
		CGRect rect = CGRectMake(
								 0.0, 
								 0.0, 
								 [self pickerView:nil widthForComponent:0],
								 [self pickerView:nil rowHeightForComponent:0]
								 );
		label = [[UILabel alloc] initWithFrame:rect];
		label.font = font;
		label.textAlignment = UITextAlignmentCenter;
	}
	label.text = [ladder objectAtIndex:row];
	
	return label;
}

@end
