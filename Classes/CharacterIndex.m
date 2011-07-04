//
//  CharacterIndex.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 7/3/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CharacterIndex.h"
#import "Character.h"
#import "CAttributeString.h"
#import "CAttributeImage.h"

static CharacterIndex *gSharedIndex;

@implementation CharacterIndex

@synthesize characters;

+ (CharacterIndex*)sharedIndex {
	if (!gSharedIndex) {
		gSharedIndex = [[CharacterIndex alloc] init];
	}
	
	return gSharedIndex;
}

- (id)init {
	self = [super init];
	if (self) {
		characters = [[NSMutableArray alloc] init];
		[self readEverything];
	}
	
	return self;
}

- (void)dealloc {
	[characters release];
	[super dealloc];
}

- (Character*)objectAtIndex:(NSUInteger)index {
	return [self.characters objectAtIndex:index];
}

- (NSString*)characterDirectoryWithFileManager:(NSFileManager*)fileManager {
	NSString *path = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Characters"];
	if (path) {
		if (![fileManager createDirectoryAtPath:path 
				   withIntermediateDirectories:YES 
									attributes:nil 
										  error:nil]) {
			
			path = nil;
		}
	}
	return path;
}

- (void)readEverything {
	NSFileManager *fm = [[NSFileManager alloc] init];
	
	if (fm) {
		NSString *characterDir = [self characterDirectoryWithFileManager:fm];
		
		if (characterDir) {
			NSArray *contents = [fm contentsOfDirectoryAtPath:characterDir
														error:nil];
			for ( NSString* oneFile in contents ) {
				NSString *oneFullPath = [characterDir stringByAppendingPathComponent:oneFile];
				if (oneFullPath) {
					id character = [NSKeyedUnarchiver unarchiveObjectWithFile:oneFullPath];
					if (character)
						[self.characters addObject:character];
				}
			}

			
			// iterate through all of the character files
			
				// read each one and put it into the array
			
		}
	
		[fm release];
	}
	
}

- (void)addCharacter:(Character*)newCharacter {
	if (newCharacter) {
		// get rid of any characters that have the same UUID
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"uuid == %@", newCharacter.uuid];
		NSArray *oldChars = [self.characters filteredArrayUsingPredicate:pred];
		
		[self.characters removeObjectsInArray:oldChars];

		[self.characters addObject:newCharacter];
		
	}
}

- (void)saveCharacter:(Character*)theCharacter {
	NSFileManager *fm = [[NSFileManager alloc] init];
	
	if (fm) {
		NSString *characterDir = [self characterDirectoryWithFileManager:fm];
		
		if (characterDir) {
			NSString *savePath = [characterDir stringByAppendingPathComponent:theCharacter.uuid];
			if (savePath) {
				if ([NSKeyedArchiver archiveRootObject:theCharacter toFile:savePath])
					[self addCharacter:theCharacter];
			}
		}
	}
	
	[self addCharacter:theCharacter];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.characters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CharacterIndexCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	Character* character = [self.characters objectAtIndex:indexPath.row];
	if (character) {
		CAttributeString *cat = [character valueForKey:@"name"];
		if (cat)
			cell.textLabel.text = cat.stringValue;
		else
			cell.textLabel.text = @"Unnamed Character";
		
		cat = [character valueForKey:@"occupation"];
		if (cat)
			cell.detailTextLabel.text = cat.stringValue;
		else
			cell.detailTextLabel.text = @"";

		CAttributeImage *cimg = [character valueForKey:@"portrait"];
		if (cimg)
			cell.imageView.image = cimg.imageValue;
		else
			cell.imageView.image = nil;
		
	}
	
	return cell;
}

@end
