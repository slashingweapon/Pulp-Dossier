//
//  TrackViewController.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/10/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAttributeTrack.h"

@interface TrackViewController : UIViewController {
	CAttributeTrack *track;
	UILabel *maxLabel;
	NSArray *boxFields;
	NSArray *consequenceFields;
	UIButton *doneBtn;
	UIButton *cancelBtn;
	NSInteger maximumValue;
	NSInteger bitfieldValue;
}

@property (nonatomic, retain) CAttributeTrack *track;
@property (nonatomic, retain) IBOutlet UILabel *maxLabel;
@property (nonatomic, retain) IBOutletCollection (UIButton) NSArray *boxFields;
@property (nonatomic, retain) IBOutletCollection (UITextField) NSArray *consequenceFields;
@property (nonatomic, retain) IBOutlet UIButton *doneBtn;
@property (nonatomic, retain) IBOutlet UIButton *cancelBtn;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)changeMax: (id)sender;
- (IBAction) toggleBox: (id)sender;
- (IBAction)putAwayKeyboard:(id)sender;

- (IBAction)scrollUp:(NSNotification*)notification;

@end

NSInteger originSort(id btn1, id btn2, void *context);
