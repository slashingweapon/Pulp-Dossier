//
//  LadderViewController.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/8/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LadderViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	id target;
	NSString *key;
	NSArray *wheelValues;
	UIPickerView *picker;
	UIButton *doneBtn;
	UIButton *cancelBtn;
	UIFont *font;
	CGFloat widest;
}

@property (nonatomic, retain) id target;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSArray *wheelValues;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UIButton *doneBtn;
@property (nonatomic, retain) IBOutlet UIButton *cancelBtn;
@property (nonatomic, retain) UIFont *font;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
