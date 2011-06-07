//
//  CAttribute.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/5/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CAttribute.h"


@implementation CAttribute

@synthesize label;

- (id)initWithString:(NSString*)inputString {
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self)
		self.label = [decoder decodeObjectForKey:@"label"];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:label forKey:@"label"];	
}

- (void)dealloc {
	[super dealloc];
	[self.label dealloc];
}

@end
