//
//  CharacterController.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 5/30/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Character;

typedef enum {
	CharacterSectionGeneral = 0,
	CharacterSectionAspects,
	CharacterSectionSkills,
	CharacterSectionStunts,
	CharacterSectionGadgets,
	CharacterSectionCount
} CharacterSection;

@interface CharacterController : UITableViewController {
	Character* character;
}

@property (nonatomic, retain) Character* character;

- (NSArray*)arrayForSection:(NSInteger)section;

@end
