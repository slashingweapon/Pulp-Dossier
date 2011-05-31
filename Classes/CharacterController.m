//
//  CharacterController.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 5/30/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CharacterController.h"
#import "Character.h"

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

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


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
		retval = 1;
	} else {
		array = [self arrayForSection:section];
		if (array) {
			retval = [array count];
			// if we're in editing mode, we'll need one more space for adding new items
			if ([self isEditing])
				retval++;
		}
	}
	
	return retval;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* sectionData;
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if (indexPath.section == CharacterSectionGeneral) {
		// Configure the cell...
		cell.textLabel.text = character.name;
	} else if (sectionData = [self arrayForSection:indexPath.section]) {
		if (indexPath.row < [sectionData count]) {
			NSDictionary* thing = [sectionData objectAtIndex:indexPath.row];
			cell.textLabel.text = [thing objectForKey:@"name"];
		} else {
			cell.textLabel.text = @"Add...";
		}
	}
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


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


@end

