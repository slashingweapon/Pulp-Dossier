//
//  CharacterController.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 5/30/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Character;
@class EditableCell;

typedef enum {
	CharacterSectionGeneral = 0,
	CharacterSectionAspects,
	CharacterSectionSkills,
	CharacterSectionStunts,
	CharacterSectionGadgets,
	CharacterSectionCount
} CharacterSection;

typedef enum {
	CharacterNameRow = 0,
	CharacterOccupationRow,
	CharacterGeneralRowCount
} CharacterGeneralRow;

@interface CharacterController : UITableViewController {
	Character* character;
}

@property (nonatomic, retain) Character* character;

- (NSArray*)arrayForSection:(NSInteger)section;
- (EditableCell*)getEditableCell;
- (UITableViewCell*)getNormalCell;

@end
