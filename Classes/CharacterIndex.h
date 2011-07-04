//
//  CharacterIndex.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 7/3/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Character;

@interface CharacterIndex : NSObject <UITableViewDataSource> {
	NSMutableArray *characters;
}

@property (readonly) NSMutableArray *characters;

+ (CharacterIndex*)sharedIndex;

- (id)init;
- (void)readEverything;
- (NSString*)characterDirectoryWithFileManager:(NSFileManager*)fileManager;
- (void)addCharacter:(Character*)newCharacter;
- (Character*)objectAtIndex:(NSUInteger)index;
- (void)saveCharacter:(Character*)theCharacter;
- (void) deleteCharacter:(Character*)theCharacter;

@end
