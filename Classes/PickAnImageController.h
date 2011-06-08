//
//  PickAnImageController.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/8/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>

/*	
 
 */
@interface PickAnImageController : UIViewController 
	<UIActionSheetDelegate, 
	UINavigationControllerDelegate, 
	UIImagePickerControllerDelegate> 
{
	id target;
	NSString *key;
}

@property (nonatomic, retain) id target;
@property (nonatomic, retain) NSString *key;

@end
