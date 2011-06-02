//
//  ResourcePicker.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/1/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResourcePicker : UITableViewController {
	NSArray *source;
	BOOL customAllowed;
	id insertTarget;
	SEL insertSelector;
	id cancelButton;
}

@property (nonatomic, retain) NSArray* source;
@property (nonatomic, assign) BOOL customAllowed;
@property (nonatomic, assign) id insertTarget;
@property (nonatomic, assign) SEL insertSelector;
@property (nonatomic, retain) id cancelButton;

- (IBAction)cancel:(id)sender;

@end
