//
//  ResourceController.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/13/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CharacterController.h"
#import "ResourcePicker.h"
#import "Character.h"
#import "CharacterIndex.h"

@implementation CharacterController

@synthesize resource;
@synthesize resourceBackup;
@synthesize data;
@synthesize canceled;
@synthesize canEdit;
@synthesize editBtn;
@synthesize cancelBtn;
@synthesize doneBtn;
@synthesize sectionHeader;

#pragma mark -
#pragma mark Initialization


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		canceled = NO;
		canEdit = YES;
    }
    return self;
}

- (void)dealloc {
	[resource release];
	[editBtn release];
	[cancelBtn release];
	[doneBtn release];
	[sectionHeader release];
	[rePick release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    if (rePick) {
		[rePick release];
		rePick = nil;
	}
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// if we never got set up with a character, make a new one now and
	// put ourselves into editing mode.
	if (!self.resource) {
		self.resource = [[Character alloc] init];
		[self setEditing:YES animated:NO];
	}

	self.tableView.allowsSelectionDuringEditing = YES;	
	if (self.editing)
		self.navigationItem.leftBarButtonItem = self.cancelBtn;
	else if (canEdit)
		self.navigationItem.rightBarButtonItem = self.editBtn;
}

- (void)viewWillDisappear:(BOOL)animated {
	// save the character
	if (self.resource)
		[[CharacterIndex sharedIndex] saveCharacter:self.resource];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows = [self.data count];
	
	if (self.editing)
		rows++;
	
    // Return the number of rows in the section.
    return rows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	if (indexPath.row < [self.data count]) {
		CAttribute *attr = [self.data objectAtIndex:indexPath.row];
		cell = [attr cellForTableView:tableView];
	} else {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil] autorelease];
	}
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle retval = UITableViewCellEditingStyleDelete;
	
	if (indexPath.row >= [self.data count])
		retval = UITableViewCellEditingStyleInsert;
		
	return retval;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		CAttribute *attr = [self.data objectAtIndex:indexPath.row];
		if (attr) {
			[self.data removeObject:attr];
			[resource.attributes removeObject:attr];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self presentAttributeTypeChooser];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	CGFloat retval = 0.0;
	
	if (!self.tableView.editing) {
		CGRect rect = self.sectionHeader.frame;
		retval = rect.size.height;
	}
	
	return retval;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *retval = nil;
	
	if (!self.tableView.editing) {
		retval = self.sectionHeader;
		self.sectionHeader.hidden = NO;
	}

	return retval;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIViewController *vc;
	
	if (indexPath.row < [self.data count]) {
		CAttribute *attr = [self.data objectAtIndex:indexPath.row];
		if (attr) {
			vc = [attr detailViewController:self.editing];
		}
	}
	
	if (vc) {
		[self presentModalViewController:vc animated:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
	} else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	
}

/*	The data object acts like a not-very-good proxy to the attribute container.  
	When we're not in editing mode, some of the attributes are displayed in the 
	section header and are omitted from the table itself.  During editing, all
	of the attributes are shown in the table.
 
	When the editing state changes, we dump the data pointer and reload the data.
 */
- (NSArray*) data {
	BOOL foundImage = NO;
	BOOL foundString = NO;
	NSMutableArray *temp = [NSMutableArray arrayWithCapacity:2];
	UIImageView *uiv;
	UILabel *lbl;
	
	if (data == nil) {
		if (!resource) {
			NSException* ex = [NSException
							   exceptionWithName:@"NoResourceException"
							   reason:@"The resource viewer requires a valid resource."
							   userInfo:nil];
			@throw ex;
		}
		
		data = [[NSMutableArray arrayWithArray:resource.attributes] retain];
		if (!self.tableView.editing) {
			// we look for the first image attribute, and the first text attribute
			for (CAttribute *att in resource.attributes) {
				if (!foundImage && [att.type isEqualToString:@"image"]) {
					uiv = (UIImageView*) [sectionHeader viewWithTag:100];
					if (uiv != nil) {
						uiv.image = [att  valueForKey:@"imageValue"];
						[temp addObject:att];
						foundImage = YES;
					}
				}
				if (!foundString && [att.type isEqualToString:@"string"]) {
					lbl = (UILabel*)[sectionHeader viewWithTag:101];
					if (lbl != nil) {
						NSString *st = [att valueForKey:@"stringValue"];
						if (st)
							lbl.text = st;
						[temp addObject:att];
						foundString = YES;
					}
				}
			}
			if ([temp count]>0)
				[data removeObjectsInArray:temp];
		}
	}
	
	return data;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate {
	[super setEditing:editing animated:animate];
	
	// Dump our data model so it will be rebuilt later
	[data release];
	data = nil;
	
	if (editing) {
		// make a backup copy of our data in case we want to cancel
		NSData *serialData = [NSKeyedArchiver archivedDataWithRootObject:resource];
		Character *newResource = [NSKeyedUnarchiver unarchiveObjectWithData:serialData];
		if (newResource) {
			self.resourceBackup = self.resource;
			self.resource = newResource;
		}
		self.navigationItem.rightBarButtonItem = doneBtn;
		self.navigationItem.leftBarButtonItem = cancelBtn;
	} else {
		self.resourceBackup = nil;
		self.navigationItem.rightBarButtonItem = editBtn;
		self.navigationItem.leftBarButtonItem = nil;
	}
 	[self.tableView reloadData];
}

- (IBAction) hitEditBtn:(id)sender {
	[self setEditing:YES animated:YES];
}

- (IBAction) hitCancelBtn:(id)sender {
	self.resource = self.resourceBackup;
	[self setEditing:NO animated:YES];
}

- (IBAction) hitDoneBtn:(id)sender {
	[self setEditing:NO animated:YES];
}

- (void) presentAttributeTypeChooser {
	if (!rePick) {
		rePick = [[ResourcePicker alloc] initWithNibName:@"ResourcePicker" bundle:nil];
		rePick.source = [NSArray arrayWithObjects:
						 [NSDictionary dictionaryWithObjectsAndKeys:
						  @"string", @"name",
						  @"CAttributeString", @"className",
						  @"Short strings (eg: character name)", @"description",
						  nil],
						 [NSDictionary dictionaryWithObjectsAndKeys:
						  @"text", @"name",
						  @"CAttributeText", @"className",
						  @"Longer strings (eg: novel contents)", @"description",
						  nil],
						 [NSDictionary dictionaryWithObjectsAndKeys:
						  @"counter", @"name",
						  @"CAttributeInteger", @"className",
						  @"A simple counter with +/- keys (eg: fate points)", @"description",
						  nil],
						 [NSDictionary dictionaryWithObjectsAndKeys:
						  @"ladder", @"name",
						  @"CAttributeLadder", @"className",
						  @"A value from Poor (-2) to Legendary (+8)", @"description",
						  nil],
						 [NSDictionary dictionaryWithObjectsAndKeys:
						  @"track", @"name",
						  @"CAttributeTrack", @"className",
						  @"For keeping track of damage (eg: health, composure)", @"description",
						  nil],
						 [NSDictionary dictionaryWithObjectsAndKeys:
						  @"image", @"name",
						  @"CAttributeImage", @"className",
						  @"A picture (eg: character portrait)", @"description",
						  nil],
						 nil];
		rePick.insertTarget = self;
		rePick.insertSelector = @selector(didPickAttributeType:);
	}
	[self.navigationController pushViewController:rePick animated:YES];
}

- (void) didPickAttributeType:(id)obj {
	Class attrClass = NSClassFromString([obj valueForKey:@"className"]);
	CAttribute *attr;
	
	attr = [attrClass alloc];
	if (attr) {
		[[attr initWithString:@""] autorelease];
		attr.label = @" ";
		// the proper way to do this is through observation
		[resource.attributes addObject:attr];
		[data addObject:attr];
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[data count]-1 inSection:0]]
							  withRowAnimation:UITableViewRowAnimationFade
		 ];

	}
}

@end

