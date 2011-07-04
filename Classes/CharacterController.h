//
//  ResourceController.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/13/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAttributeContainer.h"

@class ResourcePicker;

/*	This controller is meant to be used either as a view-only
	table in "normal" mode, or as a modal edititable table.
 
	Since we want the option of throwing away changes when we're
	in editing mode, there is a flag that tells the parent object
	if we were canceled or if we were saved.
 */
@interface CharacterController : UITableViewController {
	CAttributeContainer *resource;
	CAttributeContainer *resourceBackup;	// for rolling back cancelled edits
	BOOL canceled;
	BOOL canEdit;
	UIBarButtonItem *editBtn;
	UIBarButtonItem *cancelBtn;
	UIBarButtonItem *doneBtn;
	UIView *sectionHeader;
	NSMutableArray *data;
	ResourcePicker *rePick;
}

@property (nonatomic, retain) CAttributeContainer *resource;
@property (nonatomic, retain) CAttributeContainer *resourceBackup;
@property (nonatomic, readonly, assign) BOOL canceled;
@property (nonatomic, assign) BOOL canEdit;
@property (readonly, getter=data) NSMutableArray *data;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneBtn;
@property (nonatomic, retain) IBOutlet UIView *sectionHeader;

- (NSMutableArray*) data;

- (IBAction) hitEditBtn:(id)sender;
- (IBAction) hitCancelBtn:(id)sender;
- (IBAction) hitDoneBtn:(id)sender;

- (void) presentAttributeTypeChooser;
- (void) didPickAttributeType:(id)attrDict;

@end
