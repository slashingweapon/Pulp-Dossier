//
//  LadderCell.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/8/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "LadderCell.h"
#import "CAttributeLadder.h"

@implementation LadderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSNumber *newValue = [change valueForKey:NSKeyValueChangeNewKey];
	if ([newValue isKindOfClass:[NSNumber class]]) {
		NSString *stringValue = [CAttributeLadder stringForLevel:newValue];
		self.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%+d)", stringValue, [newValue integerValue]];
		[self setNeedsLayout];
	}
}


@end
