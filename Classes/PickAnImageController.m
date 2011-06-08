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
	CGRect frame = CGRectMake(0,0, 0, 0);
	
	self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
	self.view.alpha = 0.0;
	self.view.opaque = NO;
}

- (void)dealloc {
    [super dealloc];
	[target release];
	[key release];
}

/*	Whenever we appear, load the action sheet.  In turn, that will cause the picker controller
 to load.
 */
- (void)viewDidAppear:(BOOL)animated {
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
	
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


@end
