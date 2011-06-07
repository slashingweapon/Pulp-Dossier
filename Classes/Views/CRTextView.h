//
//  CRTextView.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/4/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//
//	This implements the display and editing of multiline text as part
//	of the resource view.

#import <UIKit/UIKit.h>
#include "CRView.h"

@interface CRTextView : CRView {
	UITextView *textView;
	UIFont *font;
}

@end
