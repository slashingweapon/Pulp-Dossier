//
//  Character.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/7/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "Character.h"
#import "CAttributeString.h"
#import "CAttributeImage.h"
#import "CAttributeLadder.h"

@implementation Character

@synthesize version;

-(id)init {
	CAttribute *attr;
	
	self = [super init];
	if (self) {
		self.version = [NSNumber numberWithInt:CHARACTER_VERSION];
		attr = [[[CAttributeImage alloc] init] autorelease];
		[self setValue:attr forKey:@"portrait"];
		attr = [[[CAttributeString alloc] init] autorelease];
		[self setValue:attr forKey:@"name"];
		attr = [[[CAttributeString alloc] init] autorelease];
		[self setValue:attr forKey:@"occupation"];
		attr = [[[CAttributeLadder alloc] initWithString:@"5"] autorelease];
		[self setValue:attr forKey:@"awesomeness"];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	if (self) {
		id obj = [decoder decodeObjectForKey:@"version"];
		if ([obj isKindOfClass:[NSNumber class]])
			self.version = obj;
	}

	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	[encoder encodeObject:version forKey:@"version"];
}


@end
