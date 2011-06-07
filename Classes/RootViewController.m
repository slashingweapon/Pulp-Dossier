//
//  RootViewController.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 5/29/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//
//	TODO: move the global character array to somewhere more appropriate
//

#import "RootViewController.h"
#import "Character.h"
#import "CharacterEditorController.h"
#import "DiceController.h"

// this doesn't belong here.  We'll move it soon...
NSMutableArray* gAllCharacters;

@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = [NSString stringWithString:@"Characters"];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																							target:self 
																							action:@selector(addCharacter:)]
											  autorelease];
	
	if (!gAllCharacters)
		gAllCharacters = [[NSMutableArray array] retain]; // [[Character readAllCharacters] retain];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
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

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [gAllCharacters count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	Character* character = [gAllCharacters objectAtIndex:indexPath.row];
	if (character) {
		NSString *attr = [character valueForKey:@"name.stringValue"];
		if (attr)
			cell.textLabel.text = attr;
		else
			cell.textLabel.text = @"Unnamed Character";
		
		
		attr = [character valueForKey:@"occupation.stringValue"];
		cell.detailTextLabel.text = (attr) ? attr : @"";
	}

	NSData* portrait = [character valueForKey:@"portrait.image"];
	if (portrait)
		cell.imageView.image = [UIImage imageWithData:portrait];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// No viewing is possible until we can add characters
	
	/*
    Character* pickedChar = [gAllCharacters objectAtIndex:indexPath.row];
	CharacterController *cc = [[CharacterController alloc] initWithNibName:@"CharacterController" bundle:nil];
	
	cc.character = pickedChar;
	[self.navigationController pushViewController:cc animated:YES];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
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
#pragma mark Custom Things

/**
 *	This gets called in response to the user hitting the big "+" button on the All Characters table.
 *	We create the character and a controller for it, put the controller into editing mode, and then push it
 *	onto our navigation controller.
 */
- (void) addCharacter:(id)sender {
	Character* newChar = [[[Character alloc] init] autorelease];
	[gAllCharacters addObject:newChar];
	
	CharacterEditorController* cc = [[CharacterEditorController alloc] initWithNibName:@"CharacterEditorController" bundle:nil];
	cc.character = newChar;
	
	[self.navigationController pushViewController:cc animated:YES];
}

@end

