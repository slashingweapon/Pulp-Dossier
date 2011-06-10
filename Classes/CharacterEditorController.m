//
//  CharacterEditorController.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/7/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CharacterEditorController.h"
#import "EditableCell.h"
#import "CAttributeImage.h"

@implementation CharacterEditorController

@synthesize character;
@synthesize doneBtn;
@synthesize cancelBtn;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.doneBtn;
	self.navigationItem.leftBarButtonItem = self.cancelBtn;	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self setEditing:YES animated:NO];
	self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewDidUnload {
	[super viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
	[character release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [character.attributes count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CAttributeCell* cell;
	
	if (indexPath.row < [character.attributes count]) {
		CAttribute *attr = [character.attributes objectAtIndex:indexPath.row];
		cell = [attr cellForTableView:tableView];
		cell.controller = self;
	}
    
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat retval = tableView.rowHeight;
	
	if (indexPath.row < [character.attributes count]) {
		CAttribute *attr = [character.attributes objectAtIndex:indexPath.row];
		if ([attr isKindOfClass:[CAttributeImage class]])
			retval = 100.0;
	}
	
	return retval;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIViewController *vc;
	
	if (indexPath.row < [character.attributes count]) {
		CAttribute *attr = [character.attributes objectAtIndex:indexPath.row];
		if (attr) {
			vc = [attr detailViewController:self.editing];
		}
	}
	
	if (vc) {
		// [self.navigationController pushViewController:vc animated:YES];
		[self presentModalViewController:vc animated:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
	} else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (EditableCell*)getEditableCell {
    static NSString *CellIdentifier = @"CharacterEditableCell";
    
    EditableCell *cell = (EditableCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[EditableCell alloc] initWithStyle:UITableViewCellStyleValue2
									reuseIdentifier:CellIdentifier] 
				autorelease];
    }
	
	return cell;
}


- (IBAction)doneEditing:(id)sender {
	NSLog(@"done editing");
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelEditing:(id)sender {
	NSLog(@"canceled editing");
	[self.navigationController popViewControllerAnimated:YES];
}

@end

