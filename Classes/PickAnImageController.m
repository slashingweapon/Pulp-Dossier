//
//  PickAnImageController.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/8/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "PickAnImageController.h"

static NSString *gTakeAPictureTitle = @"Take a Picture";
static NSString *gPickAPictureTitle = @"Choose a Picture";


@implementation PickAnImageController

@synthesize target;
@synthesize key;
@synthesize ipc;
@synthesize sheet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		// nothing to do here, really.
    }
    return self;
}

/*	Create a transparent view.  This gives us something to "display", without looking like we're 
	covering up anything underneath.
 */
- (void)loadView {
	// CGRect bounds = [[UIScreen mainScreen] bounds];
	// CGRect frame = CGRectMake(0,0, bounds.size.width, bounds.size.height);
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	
	self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
}

- (void)dealloc {
	[target release];
	[key release];
	[ipc release];
	[sheet release];
    [super dealloc];
}

/*	Whenever we appear, load the action sheet.  In turn, that will cause the picker controller
 to load.
 */
- (void)viewDidAppear:(BOOL)animated {
	if (!sheet) {
		sheet = [[UIActionSheet alloc] initWithTitle:@"" 
														   delegate:self
												  cancelButtonTitle:@"Cancel"
											 destructiveButtonTitle:nil
												  otherButtonTitles:nil, nil];
		
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
			[sheet addButtonWithTitle:gTakeAPictureTitle];
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
			[sheet addButtonWithTitle:gPickAPictureTitle];
		[sheet showInView:self.view];
	} else {
		self.sheet = nil;
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (void)actionSheet:(UIActionSheet *)sheetx clickedButtonAtIndex:(NSInteger)buttonIndex {
	UIImagePickerControllerSourceType source;
	NSString* buttonTitle = [sheetx buttonTitleAtIndex:buttonIndex];
	BOOL canceled = NO;
	
	// which source did the user pick?
	if ([buttonTitle compare:gTakeAPictureTitle] == NSOrderedSame)
		source = UIImagePickerControllerSourceTypeCamera;
	else if ([buttonTitle compare:gPickAPictureTitle] == NSOrderedSame)
		source = UIImagePickerControllerSourceTypePhotoLibrary;
	else
		canceled = YES;
	
	if (!canceled) {
		self.ipc = [[[UIImagePickerController alloc] init] autorelease];
		[ipc setSourceType: source];
		[ipc setDelegate:self];
		ipc.allowsEditing = YES;
		[self presentModalViewController:ipc animated:YES];
	} else {
		[self.parentViewController dismissModalViewControllerAnimated:YES];
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
		
		UIGraphicsEndImageContext();
		
		if (self.target && self.key)
			[self.target setValue:image forKey:key];		
	}
	
	[self dismissModalViewControllerAnimated:YES];
	// [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissModalViewControllerAnimated:YES];
	// [self dismissModalViewControllerAnimated:YES];
}


@end
