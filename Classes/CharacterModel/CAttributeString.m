//
//  CAttributeString.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/6/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CAttributeString.h"


@implementation CAttributeString

@synthesize stringValue;

- (id)initWithString:(NSString*)inputString {
	self.stringValue = inputString;
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
	
	if (self)
		self.stringValue = [decoder decodeObjectForKey:@"stringValue"];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    [encoder encodeObject:label forKey:@"label"];	
}

- (void)dealloc {
	[super dealloc];
	[self.stringValue dealloc];
}


@end
