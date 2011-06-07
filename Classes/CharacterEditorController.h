//
//  CharacterEditorController.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/7/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character.h"

@class EditableCell;

@interface CharacterEditorController : UITableViewController {
	Character*	character;
	UIBarButtonItem* doneBtn;
	UIBarButtonItem* cancelBtn;
}

@property (nonatomic,retain) Character* character;
@property (nonatomic,retain) IBOutlet UIBarButtonItem* doneBtn;
@property (nonatomic,retain) IBOutlet UIBarButtonItem* cancelBtn;

- (IBAction)doneEditing:(id)sender;
- (IBAction)cancelEditing:(id)sender;

- (EditableCell*)getEditableCell;

@end
