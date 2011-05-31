//
//  Character.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 5/30/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "Character.h"


@implementation Character

@synthesize formatVersion;
@synthesize characterVersion;
@synthesize portrait;
@synthesize name;
@synthesize occupation;
@synthesize fatePoints;
@synthesize refreshRate;
@synthesize health;
@synthesize healthTrack;
@synthesize composure;
@synthesize composureTrack;
@synthesize consequences;
@synthesize aspects;
@synthesize skills;
@synthesize stunts;
@synthesize gadgets;
@synthesize dirty;

- (id)init {
	self = [super init];
	
	if (self) {
		self.formatVersion = CHARACTER_FORMAT_VERSION;
		self.characterVersion = 0;
		self.name = @"";
		self.occupation = @"";
		self.fatePoints = 0;
		self.refreshRate = 0;
		self.health = 5;
		self.composure = 5;
		self.healthTrack = @"";
		self.composureTrack = @"";
		self.consequences = [NSMutableArray arrayWithCapacity:3];
		self.aspects = [NSMutableArray arrayWithCapacity:10];
		self.skills = [NSMutableArray arrayWithCapacity:15];
		self.stunts = [NSMutableArray arrayWithCapacity:5];
		self.gadgets = [NSMutableArray array];
		self.dirty = YES;
	}
	
	return self;
}

- (void) dealloc {
	[portrait release];
	[name release];
	[occupation release];
	[consequences release];
	[aspects release];
	[skills release];
	[stunts release];
	[gadgets release];
	
	[filePath release];
	
	[super dealloc];
}

/**
 *	The errors here might be better handled with exceptions, since there's no legitimate 
 *	reasons for them to fail.
 *
 *	Returns YES on success.  On failure, returns NO and sets *error.
 */
- (BOOL)saveWithError:(NSString**)error {
	NSString* errorResult = nil;
	
	if (!filePath) {
		if ([name isEqualToString:@""])
			errorResult = @"Can not save characters with an empty name.";
		else {
			filePath = [Character createSavePathForName:name];
			if (!filePath) {
				errorResult = @"Could not create Character directory";
			}
		}
	}

	// actualy writing the thing to disk is rediculously easy, since we support NSCoding
	if (!errorResult) {
		if (dirty) {
			self.characterVersion++;
		}
		if (![NSKeyedArchiver archiveRootObject:self toFile:filePath]) 
			errorResult = @"The Archvist has failed you for the last time!";
	}

	if (errorResult) {
		*error = errorResult;
	}
	
	return errorResult ? NO : YES;
}

/**
 *	Creates a path with the following guarantees:
 *	- is in the Documents/Characters directory
 *	- is not currently being used by another file
 *
 *	Returns nil on failure, which can only happen if the Characters directory can not be created
 *	or accessed.
 */
+ (NSString*) createSavePathForName:(NSString*)characterName {
	NSArray* docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* charPath = [[docPaths objectAtIndex:0] stringByAppendingPathComponent:@"Characters"];
	NSFileManager* fm = [[[NSFileManager alloc] init] autorelease];
	NSString* savePath;
	NSInteger tryCount = 0;
	NSError* err;
	
	if ( [fm createDirectoryAtPath:charPath 
	   withIntermediateDirectories:YES 
						attributes:nil 
							 error:&err]) {
		
		// First, try using the filename <charname>.data and if that doesn't work, resort
		// to 1000 iterations of <charname>.<num>.data.
		savePath = [charPath stringByAppendingPathComponent:characterName];
		savePath = [savePath stringByAppendingPathExtension:@"data"];
		while ([fm fileExistsAtPath:savePath] && tryCount<1000) {
			savePath = [charPath stringByAppendingPathComponent:characterName];
			savePath = [savePath stringByAppendingPathExtension:[NSString stringWithFormat:@"%d", tryCount]];
			savePath = [savePath stringByAppendingPathExtension:@"data"];
		}
		
		// We tried.  We really did...
		if (tryCount>=1000)
			savePath = nil;
		
	} else {
		NSLog(@"Error with character directiory %d: %@ ", err.code, err.localizedDescription);
	}
	
	return savePath;
}


#pragma mark NSCoding implementation

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt:formatVersion forKey:@"formatVersion"];
	[encoder encodeInt:characterVersion forKey:@"characterVersion"];
	[encoder encodeObject:portrait	forKey:@"portrait"];
	[encoder encodeObject:name forKey:@"name"];
	[encoder encodeObject:occupation forKey:@"occupation"];
	[encoder encodeInt:fatePoints forKey:@"fatePoints"];
	[encoder encodeInt:refreshRate forKey:@"refreshRate"];
	[encoder encodeInt:health forKey:@"health"];
	[encoder encodeObject:healthTrack forKey:@"healthTrack"];
	[encoder encodeInt:composure forKey:@"composure"];
	[encoder encodeObject:composureTrack forKey:@"composureTrack"];
	[encoder encodeObject:consequences forKey:@"consequences"];
	[encoder encodeObject:aspects forKey:@"aspects"];
	[encoder encodeObject:skills forKey:@"skills"];
	[encoder encodeObject:stunts forKey:@"stunts"];
	[encoder encodeObject:gadgets forKey:@"gadgets"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super init];
	
	if (self) {
		// Using the . operator will ensure assignments through our accessor
		// methods, which will take care of retain counts.
		self.formatVersion = [decoder decodeIntForKey:@"formatVersion"];
		self.characterVersion = [decoder decodeIntForKey:@"characterVersion"];
		self.portrait = [decoder decodeObjectForKey:@"portrait"];
		self.name = [decoder decodeObjectForKey:@"name"];
		self.occupation = [decoder decodeObjectForKey:@"occupation"];
		self.fatePoints = [decoder decodeIntForKey:@"fatePoints"];
		self.refreshRate = [decoder decodeIntForKey:@"refreshRate"];
		self.health = [decoder decodeIntForKey:@"health"];
		self.healthTrack = [decoder decodeObjectForKey:@"healthTrack"];
		self.composure = [decoder decodeIntForKey:@"composure"];
		self.composureTrack = [decoder decodeObjectForKey:@"composureTrack"];
		self.consequences = [decoder decodeObjectForKey:@"consequences"];
		self.aspects = [decoder decodeObjectForKey:@"aspects"];
		self.skills = [decoder decodeObjectForKey:@"skills"];
		self.stunts = [decoder decodeObjectForKey:@"stunts"];
		self.gadgets = [decoder decodeObjectForKey:@"gadets"];
	}
	
	return self;
}

@end
