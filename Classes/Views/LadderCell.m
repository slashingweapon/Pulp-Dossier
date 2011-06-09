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


- (void)dealloc {
    [super dealloc];
}

- (void)setTarget:(id)target withKey:(NSString*)key {
	// unregister any old observers
	if (dataTarget)
		[dataTarget removeObserver:self forKeyPath:dataKey];
	
	[super setTarget:target withKey:key];
	
	// register as an observer of our target object
	if (dataTarget) {
		[dataTarget addObserver:self 
					 forKeyPath:key 
						options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial 
						context:nil];
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSNumber *newValue = [change valueForKey:NSKeyValueChangeNewKey];
	if ([newValue isKindOfClass:[NSNumber class]]) {
		NSString *stringValue = [CAttributeLadder stringForLevel:newValue];
		self.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%+d)", stringValue, [newValue integerValue]];
		[self setNeedsDisplay];
	}
}


@end
