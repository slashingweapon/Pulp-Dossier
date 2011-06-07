//
//  CRTextView.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/4/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CRTextView.h"


@implementation CRTextView


- (id)initWithFrame:(CGRect)frame {
	font = [[UIFont fontWithName:@"American Typewriter" size:17] retain];
	frame.size.height = font.lineHeight;
	
    self = [super initWithFrame:frame];
    if (self) {
		frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
		textView = [[UITextView alloc] initWithFrame:frame];
		textView.font = font;
		textView.textAlignment = UITextAlignmentLeft;
		textView.editable = false;
		[self addSubview:textView];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
	[textView release];
}

- (void)setParams:(NSDictionary*)dict withDataSource:(id)source {
	[super setParams:dict withDataSource:source];
	CGRect rect = self.frame;

	NSString *text = [self getSourceString];
	if (text) {
		rect.size.height = 210;
		CGSize size = [text sizeWithFont:font constrainedToSize:rect.size];
		size.height += font.lineHeight;
		rect.size = size;
		textView.frame = rect;
		self.frame = rect;
	}
	
	textView.text = [self getSourceString];
}


@end
