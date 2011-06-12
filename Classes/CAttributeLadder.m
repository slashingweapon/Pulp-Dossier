//
//  CAttributeLadder.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/8/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CAttributeLadder.h"
#import "IntegerCell.h"

static NSArray* gLevelStrings;

@implementation CAttributeLadder

@synthesize levelValue;

- (id)initWithString:(NSString*)inputString {
	self = [super initWithString:inputString];
	if (self) {
		if (inputString)
			self.levelValue = [NSNumber numberWithInt:[inputString integerValue]];
		else
			self.levelValue = [NSNumber numberWithInt:1];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	if (self) {
		NSNumber *num = [decoder decodeObjectForKey:@"levelValue"];
		if ([num isKindOfClass:[NSNumber class]])
			self.levelValue = num;
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	[encoder encodeObject:self.levelValue forKey:@"levelValue"];
}

-(BOOL)validateLevelValue:(id *)ioValue error:(NSError **)outError {
	static NSString *errorString = @"Ladder values must be NSNumbers between -2 and 8";
	NSInteger intValue;
	BOOL retval = YES;
	
	if ([*ioValue isKindOfClass:[NSNumber class]]) {
		NSNumber *inNum = *ioValue;
		intValue = [inNum integerValue];
	} else {
		retval = NO;
	}
	
	if (! (retval && intValue >= -2 && intValue <= 8)) {
		retval = NO;
		*outError = [NSError errorWithDomain:@"Pulp Dossier" 
										code:100 
									userInfo:[NSDictionary dictionaryWithObject:errorString 
																		 forKey:NSLocalizedDescriptionKey
											  ]
					 ];
	}
	
	return retval;
}

- (UITableViewCell*)cellForTableView:(UITableView *)tableView {
	static NSString* cellIdentifier = @"CAttributeLadderCell";
	IntegerCell* cell = (IntegerCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (![cell isKindOfClass:[IntegerCell class]]) {
		cell = [[[IntegerCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier] autorelease];
	}
	
	if (cell != nil) {
		cell.textLabel.text = self.label;
		cell.formatSelector = @selector(levelAsString);
		[cell setTarget:self withKey:@"levelValue"];
		cell.minValue = -2;
		cell.maxValue = 8;
	}
	
	return cell;
}

- (NSString*) levelAsString {
	return [NSString stringWithFormat:@"%@ (%+d)", 
			[CAttributeLadder stringForLevel:levelValue], 
			[levelValue integerValue]];
}

+ (NSString*) stringForLevel:(NSNumber*)level {
	NSArray* allLevels = [self allLevelStrings];
	
	NSInteger index = [level intValue];
	index = 8 - index;
	
	if (index < 0) {
		index = 0;
	} else if (index > [allLevels count]) {
		index = [allLevels count] - 1;
	}
	
	return [allLevels objectAtIndex:index];
}

+ (NSArray*) allLevelStrings {
	if (gLevelStrings == nil) {
		// we organize these from best to worst, because that is how the UI
		// displays them.
		gLevelStrings = [[NSArray arrayWithObjects:
						  @"Legendary", // +8
						  @"Epic",
						  @"Fantastic",
						  @"Superb",
						  @"Great",
						  @"Good",
						  @"Fair",
						  @"Average",
						  @"Mediocre",	// +0
						  @"Poor",
						  @"Terrible",  // -2
						  nil
						  ] retain];
	}
	return gLevelStrings;
}

@end
