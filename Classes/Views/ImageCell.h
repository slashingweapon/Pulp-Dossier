//
//  ImageCell.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/7/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAttributeCell.h"

@interface ImageCell : CAttributeCell {
	// we're not keeping refcounts on either of these, because they get retained
	// via our subviews.
	UIButton* imageButton;
	UIImage* imageBackground;
}

- (IBAction)pickImage:(id)sender;

@end
