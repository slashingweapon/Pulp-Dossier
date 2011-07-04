//
//  CharacterIndex.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 7/3/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CharacterIndex.h"


@implementation CharacterIndex

@synthesize characters;

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
				NSString *oneFullPath = [oneFile stringByAppendingPathComponent:oneFile];
				if (oneFullPath) {
					NSData *rawData = [fm contentsAtPath:oneFullPath];
					if (rawData) {
						
					}
				}
			}

			
			// iterate through all of the character files
			
				// read each one and put it into the array
			
		}
	
		[fm release];
	}
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.characters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

@end
