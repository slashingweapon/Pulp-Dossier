//
//  EditableCell.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 5/31/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditableCell : UITableViewCell {
	UITextField *textField;
	id dataTarget;
	NSString *dataKey;
}

@property (nonatomic, readonly) UITextField *textField;

/**
 *	Set the source of the text data here.  The cell will pull the NSString data
 *	using Key-Value Coding.
 */
- (void)setTarget:(id)target withKey:(NSString*)key;

@end
