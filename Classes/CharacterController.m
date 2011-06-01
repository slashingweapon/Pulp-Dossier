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

@implementation CharacterController

@synthesize character;

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

- (NSArray*)arrayForSection:(NSInteger)section {
	NSArray* retval = nil;
	
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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return [NSArray arrayWithObjects:@"", @"Aspects", @"Skills", @"Stunts", @"Gadgets", nil];
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
			// Delete the row from the data source.
			//[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}   
		else if (editingStyle == UITableViewCellEditingStyleInsert) {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}   		
	}
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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

#pragma mark -
#pragma mark Controller Methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	NSString* err = nil;
	
	if (!editing) {
		[character saveWithError:&err];
		if (err) {
			NSLog(@"%@", err);
		}
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


@end

