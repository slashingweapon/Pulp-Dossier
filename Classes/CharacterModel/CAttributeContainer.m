//
//  CAttributeContainer.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/6/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CAttributeContainer.h"


@implementation CAttributeContainer

@synthesize attributes;

-(id)init {
	self = [super init];
	if (self)
		self.attributes = [NSArray array];
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	self.attributes = [decoder decodeObjectForKey:@"attributes"];
	if (self.attributes == nil)
		self.attributes = [NSArray array];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:attributes forKey:@"attributes"];
}

- (void)dealloc {
	[super dealloc];
	[self.attributes dealloc];
}


@end
