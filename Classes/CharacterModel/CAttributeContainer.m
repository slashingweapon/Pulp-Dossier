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
		self.attributes = [NSMutableArray array];
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

- (id)valueForUndefinedKey:(NSString *)key {
	id retval = nil;
	
	NSPredicate *labelPredicate = [NSPredicate predicateWithFormat:@"label like %@", key];
	NSArray *foundItems = [self.attributes filteredArrayUsingPredicate:labelPredicate];
	if (foundItems && [foundItems count])
		retval = [foundItems objectAtIndex:0];
	
	return retval;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	id oldValue;
	
	if ([value isKindOfClass:[CAttribute class]]) {
		CAttribute *attr = value;
		attr.label = key;

		oldValue = [self valueForUndefinedKey:key];
		if (oldValue) {
			NSInteger index = [self.attributes indexOfObject:oldValue];
			[self.attributes replaceObjectAtIndex:index withObject:attr];
		} else {
			[self.attributes addObject:attr];
		}
	} else if (value == nil) {
		oldValue = [self valueForUndefinedKey:key];
		if (oldValue)
			[self.attributes removeObject:oldValue];
	}
}

-(NSUInteger)countOfAttributes {
	return [self.attributes count];
}

-(id)objectInAttributesAtIndex:(NSUInteger)index {
	return [self.attributes objectAtIndex:index];
}

- (void)insertObject:(id)anObject inAttributesAtIndex:(NSUInteger)index {
	[self.attributes insertObject:anObject atIndex:index];
}

- (void)removeObjectFromAttributesAtIndex:(NSUInteger)index {
	[self.attributes removeObjectAtIndex:index];
}

-(void)replaceObjectInAttributesAtIndex:(NSUInteger)index withObject:(id)anObject {
	[self.attributes replaceObjectAtIndex:index withObject:anObject];
}

@end
