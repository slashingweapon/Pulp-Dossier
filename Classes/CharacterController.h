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

@interface CharacterController : UITableViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	Character *character;
	id profileButton;
}

@property (nonatomic, retain) Character *character;
@property (nonatomic, retain) IBOutlet id profileButton;

- (NSMutableArray*)arrayForSection:(NSInteger)section;
- (EditableCell*)getEditableCell;
- (UITableViewCell*)getNormalCell;
- (IBAction) changeProfile:(id)sender;

@end
