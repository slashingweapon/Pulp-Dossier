//
//  IntegerCell.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/12/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAttributeCell.h"

@interface IntegerCell : CAttributeCell {
	UISegmentedControl *segV;
	NSInteger minValue;
	NSInteger maxValue;
	NSInteger currentValue;
	SEL formatSelector;
}

@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, assign) SEL formatSelector;

- (IBAction) changeValue:(id)sender;

@end
