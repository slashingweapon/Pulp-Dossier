//
//  CharacterIndex.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 7/3/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CharacterIndex : NSObject <UITableViewDataSource> {
	NSMutableArray *characters;
}

@property (readonly) NSMutableArray *characters;

- (id)init;
- (void)readEverything;
- (NSString*)characterDirectoryWithFileManager:(NSFileManager*)fileManager;

@end
