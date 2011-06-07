//
//  CRLadderView.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/4/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRView.h"

@interface CRLadderView : CRView <UIPickerViewDelegate, UIPickerViewDataSource> {
	UIPickerView *picker;
	NSArray *ladder;
	UIFont *font;
}

@end
