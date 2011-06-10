//
//  LadderViewController.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/8/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "LadderViewController.h"
#import "CAttributeLadder.h"

@implementation LadderViewController

@synthesize target;
@synthesize key;
@synthesize wheelValues;
@synthesize picker;
@synthesize doneBtn;
@synthesize cancelBtn;
@synthesize font;

- (id)initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle {
    self = [super initWithNibName:nib bundle:bundle];
    if (self) {
		self.wheelValues = [CAttributeLadder allLevelStrings];
		self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
		widest = 0.0;
    }
    return self;
}

- (void)dealloc {
	[super dealloc];
	[target release];
	[key release];
	[wheelValues release];
	[picker release];
	[doneBtn release];
	[cancelBtn release];
	[font release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	NSInteger index = 7;
	if (target && key) {
		NSNumber *num = [target valueForKey:key];
		index = 8 - [num integerValue];
	}
	[picker selectRow:index inComponent:0 animated:animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [wheelValues count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return font.lineHeight;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

	if (widest == 0.0) {
		for (NSString *oneLabel in self.wheelValues) {
			CGSize oneSize = [oneLabel sizeWithFont:font];
			if (oneSize.width > widest)
				widest = oneSize.width;
		}
		widest += 80.0;
	}
	
	return widest;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *label;
	NSString *labelText = [wheelValues objectAtIndex:row];
	CGSize labelSize = [labelText sizeWithFont:font];
	CGRect rect = CGRectMake(0, 
							 0,
							 widest,
							 labelSize.height);
	
	
	if ([view isKindOfClass:[UILabel class]])
		label = (UILabel*)view;
	else
		label = [[[UILabel alloc] initWithFrame:rect] autorelease];
	
	label.frame = rect;
	label.font = font;
	label.text = labelText;
	label.textAlignment = UITextAlignmentCenter;
	
	return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	doneBtn.titleLabel.text = [@"Choose " stringByAppendingString:[wheelValues objectAtIndex:row]];
}

- (IBAction)done:(id)sender {
	// [self.navigationController popViewControllerAnimated:YES];
	[self dismissModalViewControllerAnimated:YES];
	if (target && key) {
		NSInteger row = [picker selectedRowInComponent:0];

		NSNumber *level = [NSNumber numberWithInteger:8-row];
		[target setValue:level forKey:key];
	}
}

- (IBAction)cancel:(id)sender {
	// [self.navigationController popViewControllerAnimated:YES];
	[self dismissModalViewControllerAnimated:YES];
}


@end
