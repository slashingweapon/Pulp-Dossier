//
//  CharacterController.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 5/30/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CharacterController.h"
#import "Character.h"
#import "EditableCell.h"
#import "DiceController.h"
#import "Sourcebook.h"
#import "ResourcePicker.h"

static NSString *gTakeAPictureTitle = @"Take a picture";
static NSString *gPickAPictureTitle = @"Choose a picture";

@implementation CharacterController

@synthesize character;
@synthesize profileButton;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if ([self.character.name length])
		self.title = self.character.name;
	else
		self.title = @"Unnamed Character";
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self resignFirstResponder];
}


#pragma mark -
#pragma mark Table view data source

- (NSMutableArray*)arrayForSection:(NSInteger)section {
	NSMutableArray* retval = nil;
	
	switch (section) {
		case CharacterSectionAspects:
			retval = character.aspects;
			break;
		case CharacterSectionSkills:
			retval = character.skills;
			break;
		case CharacterSectionStunts:
			retval = character.stunts;
			break;
		case CharacterSectionGadgets:
			retval = character.gadgets;
			break;
		case CharacterSectionGeneral:
		default:
			break;
	}
	
	return retval;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return CharacterSectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *retval;
	
	switch (section) {
		case CharacterSectionAspects:
			retval = @"Aspects";
			break;
		case CharacterSectionSkills:
			retval = @"Skills";
			break;
		case CharacterSectionStunts:
			retval = @"Stunts";
			break;
		case CharacterSectionGadgets:
			retval = @"Gadgets";
			break;
		default:
			break;
	}
	return retval;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger retval = 0;
	NSArray* array;
	
	if (section == CharacterSectionGeneral) {
		retval = CharacterGeneralRowCount;
	} else {
		array = [self arrayForSection:section];
		if (array) {
			retval = [array count];
		}
		// if we're in editing mode, we'll need one more space for adding new items
		if ([self isEditing])
			retval++;
	}
	
	return retval;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* sectionData;
	UITableViewCell *cell;
	
	if (indexPath.section == CharacterSectionGeneral) {
		EditableCell *ecell;
		
		// Configure the cell depending on the row...
		switch (indexPath.row) {
			case CharacterNameRow:
				ecell = [self getEditableCell];
				ecell.textLabel.text = character.name;
				[ecell setTarget:character withKey:@"name"];
				cell = ecell;
				break;
			case CharacterOccupationRow:
				ecell = [self getEditableCell];
				ecell.textLabel.text = character.occupation;
				[ecell setTarget:character withKey:@"occupation"];
				cell = ecell;
				break;
		}
	} else if (sectionData = [self arrayForSection:indexPath.section]) {
		cell = [self getNormalCell];
		if (indexPath.row < [sectionData count]) {
			NSDictionary* thing = [sectionData objectAtIndex:indexPath.row];
			cell.textLabel.text = [thing objectForKey:@"name"];
		} else {
			cell.textLabel.text = @"Add...";
		}
	}
	
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section != CharacterSectionGeneral) {
		if (editingStyle == UITableViewCellEditingStyleDelete) {
			NSMutableArray *dataArray = [self arrayForSection:indexPath.section];
			if (dataArray != nil && indexPath.row < [dataArray count]) {
				[dataArray removeObjectAtIndex:indexPath.row];
				[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			}
		} else if (editingStyle == UITableViewCellEditingStyleInsert) {
			ResourcePicker *rp = [[ResourcePicker alloc] initWithNibName:@"ResourcePicker" bundle:nil];

			switch (indexPath.section) {
				case CharacterSectionAspects:
					rp.source = [[Sourcebook sharedSourcebook] valueForKey:@"aspects"];
					rp.insertTarget = self;
					rp.insertSelector = @selector(insertAspect:);
					rp.customAllowed = YES;
					rp.title = @"Aspects";
					break;
				case CharacterSectionSkills:
					rp.source = [[Sourcebook sharedSourcebook] valueForKey:@"skills"];
					rp.insertTarget = self;
					rp.insertSelector = @selector(insertSkill:);
					rp.customAllowed = NO;
					rp.title = @"Skills";
					break;
				/*
				case CharacterSectionStunts:
					rp.source = [[Sourcebook sharedSourcebook] valueForKey:@"stunts"];
					rp.insertTarget = self;
					rp.insertSelector = @selector(insertStunt:);
					rp.customAllowed = NO;
					rp.title = @"Stunts";
					break;
				case CharacterSectionGadgets:
					rp.source = [[Sourcebook sharedSourcebook] valueForKey:@"gadets"];
					rp.insertTarget = self;
					rp.insertSelector = @selector(insertGaget:);
					rp.customAllowed = NO;
					rp.title = @"Gadgets";
					break;
				*/
			}
			
			[self.navigationController pushViewController:rp animated:YES];			
		}   		
	}
}

- (void)insertAspect:(NSMutableDictionary*)aspect {
	if (aspect == nil) {
		aspect = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"name", @"", @"description", nil];
	} else {
		aspect = [NSMutableDictionary dictionaryWithDictionary:aspect]; // make a new copy of the data
	}
	
	[self.character.aspects addObject:aspect];
	
	[self.tableView reloadData];
}

- (void)insertSkill:(NSMutableDictionary*)skill {
	if (skill != nil) {
		skill = [NSMutableDictionary dictionaryWithDictionary:skill]; // make a new copy of the data
		[self.character.skills addObject:skill];
		[self.tableView reloadData];
	}
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}

/**
 *	Set the style for the various rows of the table.  In the general section, all of the cells are edited 
 *	in-place so they don't need an editing control.  In the array-based views, all of the items have a
 *	delete control, except for the "Add..." item which gets an insertion control.
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
	
	if (indexPath.section != CharacterSectionGeneral) {
		if (indexPath.row < [[self arrayForSection:indexPath.section] count])
			style = UITableViewCellEditingStyleDelete;
		else
			style = UITableViewCellEditingStyleInsert;
	}
	return style;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	CGRect rect;
	UIView *retval = nil;
	
	rect = CGRectMake(0.0, 0.0, 32, 32);

	if (section == CharacterSectionGeneral) {
		UIImage *image;
		UIButton *button = self.profileButton;
		
		if (character.portrait) {
			image = [[[UIImage alloc] initWithData:character.portrait] autorelease];
		} else {
			image = [UIImage imageNamed:@"Icon.png"];
		}
		[button setImage:image forState:UIControlStateNormal];
		retval = button;
		/*
		retval = [[[UIImageView alloc] initWithImage:image] autorelease];
		retval.contentMode = UIViewContentModeScaleAspectFit;
		retval.frame = rect;
		 */
	}
	
	return retval;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return (section == CharacterSectionGeneral) ? 100.0 : 32.0 ;
}

#pragma mark -
#pragma mark Controller Methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	NSString* err = nil;
	
	if (editing) {
		[self.tableView reloadData];
	} else {
		[self.view endEditing:YES];
		[character saveWithError:&err];
		if (err) {
			NSLog(@"%@", err);
		}
		[self.tableView reloadData];
	}
}

#pragma mark -
#pragma mark Motion Handling

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{	
	if (motion == UIEventSubtypeMotionShake) {
		DiceController* dc = [[DiceController alloc] initWithNibName:@"DiceController" bundle:nil];
		[self.navigationController pushViewController:dc animated:YES];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	self.profileButton = nil;
	self.character = nil;
}

- (UITableViewCell*)getNormalCell {
    static NSString *CellIdentifier = @"CharacterNormalCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:CellIdentifier] 
				autorelease];
    }
	
	return cell;
}

- (EditableCell*)getEditableCell {
    static NSString *CellIdentifier = @"CharacterEditableCell";
    
    EditableCell *cell = (EditableCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[EditableCell alloc] initWithStyle:UITableViewCellStyleDefault
									reuseIdentifier:CellIdentifier] 
				autorelease];
    }
	
	return cell;
}

/**
 *	Show an action sheet asking how the user wants to pick his picture.  We only show buttons for the input
 *	sources that are available, of course.
 */
- (IBAction) changeProfile:(id)sender {
	if (self.editing) {
		UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"" 
														   delegate:self
												  cancelButtonTitle:@"Cancel"
											 destructiveButtonTitle:nil
												  otherButtonTitles:nil, nil];

		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
			[sheet addButtonWithTitle:gTakeAPictureTitle];
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
			[sheet addButtonWithTitle:gPickAPictureTitle];
		[sheet showInView:self.view];
	}
}

/**
 *	Launch an image picker, with the source selected by the user.
 */
- (void)actionSheet:(UIActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	UIImagePickerControllerSourceType source;
	NSString* buttonTitle = [sheet buttonTitleAtIndex:buttonIndex];
	BOOL canceled = NO;
	
	// which source did the user pick?
	if ([buttonTitle compare:gTakeAPictureTitle] == NSOrderedSame)
		source = UIImagePickerControllerSourceTypeCamera;
	else if ([buttonTitle compare:gPickAPictureTitle] == NSOrderedSame)
		source = UIImagePickerControllerSourceTypePhotoLibrary;
	else
		canceled = YES;

	if (!canceled) {
		UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
		[ipc setSourceType: source];
		[ipc setDelegate:self];
		ipc.allowsEditing = YES;
		[self presentModalViewController:ipc animated:YES];
		[ipc release];
	}
}

/**
 *	Take either the edited/cropped image, or the original image, and make it the portrait for the character.
 *	We resize the image to 100 points, because we don't want to save any more data than is really necessary.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

	if (image == nil)
		image = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	if (image != nil) {
		CGRect imageRect = CGRectMake(0,0,100,100);
		
		UIGraphicsBeginImageContext(imageRect.size);
		[image drawInRect:imageRect];
		image = UIGraphicsGetImageFromCurrentImageContext();
		[image retain];

		UIGraphicsEndImageContext();
		
		[self.profileButton setImage:image forState:UIControlStateNormal];
		self.character.portrait = UIImagePNGRepresentation(image);
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

@end

