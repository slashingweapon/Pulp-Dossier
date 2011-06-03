//
//  ResourcePicker.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/1/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "ResourcePicker.h"


@implementation ResourcePicker

@synthesize source;
@synthesize customAllowed;
@synthesize insertTarget;
@synthesize insertSelector;
@synthesize cancelButton;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.cancelButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[self.source release];
	[self.cancelButton release];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger retval = 0;
	
	if (source != nil)
		retval = [source count];
	if (customAllowed)
		retval++;

    return retval;
}


#define SUBSTRING_SIZE 20

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PickerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (source != nil && indexPath.row < [source count]) {
		id item = [source objectAtIndex:indexPath.row];
		NSString *text;
		text = [item valueForKey:@"name"];
		if (text) cell.textLabel.text = text;
		
		text = [item valueForKey:@"description"];
		if ([text length] > SUBSTRING_SIZE)
			text = [text substringToIndex:SUBSTRING_SIZE];
		if (text) cell.detailTextLabel.text = text;
	} else {
		cell.textLabel.text = @"Custom...";
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

/**
 *	Call the target object (insertTarget) with the appropriate selector (insertSelector)
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *resultItem = nil;
	
	if (source && indexPath.row < [source count]) {
		resultItem = [source objectAtIndex:indexPath.row];
	}
	
	if (insertTarget && insertSelector && [insertTarget respondsToSelector:insertSelector]) {
		[insertTarget performSelector:insertSelector withObject:resultItem];
	}
	[self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

@end

