//
//  CAttributeCell.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/7/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CAttributeCell.h"


@implementation CAttributeCell

@synthesize dataTarget;
@synthesize dataKey;
@synthesize controller;

- (void)dealloc {
	[self setTarget:nil withKey:nil];
	
    [super dealloc];
	[dataTarget release];
	[dataKey release];
}

- (void)setTarget:(id)target withKey:(NSString*)key {
	dataTarget = [target retain];
	dataKey = [key retain];	
}

- (void)prepareForReuse {
	[self setTarget:nil withKey:nil];
	controller = nil;
}

@end
