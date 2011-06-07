//
//  CRTitleView.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/4/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CRTitleView.h"


@implementation CRTitleView


- (id)initWithFrame:(CGRect)frame {
	UIFont *font = [UIFont fontWithName:@"American Typewriter" size:24];
	frame.size.height = font.lineHeight;
	
    self = [super initWithFrame:frame];
    if (self) {
		frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
		label = [[UILabel alloc] initWithFrame:frame];
		label.font = font;
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
	[label release];
}

- (void)setParams:(NSDictionary*)dict withDataSource:(id)source {
	[super setParams:dict withDataSource:source];
	
	label.text = [self getSourceString];
}


@end
