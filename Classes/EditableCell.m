//
//  EditableCell.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 5/31/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "EditableCell.h"


@implementation EditableCell

@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        textField = [[UITextField alloc] initWithFrame:CGRectZero];
		textField.adjustsFontSizeToFitWidth = YES;
		// Instead of a "Return" button, our keyboard will have a "Done" button.  When it is hit, we 
		// want to put away the keyboard.
		textField.returnKeyType = UIReturnKeyDone;
		[textField addTarget:self
					  action:@selector(doneWithKeyboard:)
			forControlEvents:UIControlEventEditingDidEnd | UIControlEventEditingDidEndOnExit];
		
		[self.contentView addSubview:textField];
		[textField release];	// we let the contentView own the textField
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


/**
 *	When laying out the subviews, we check to see if we are in editing mode.  If we are, then we place the textField right
 *	where the standard textLabel would normally go, copy the textLabel's data, and then hide the textLabel.  If we aren't
 *	editing, then we just hide the textField and reveal the textLabel.
 */
- (void)layoutSubviews {
	[super layoutSubviews];
	
	if (self.editing) {
		float inset = 10.0;
		CGRect bounds = self.contentView.frame;
		CGRect frame = CGRectMake(inset, inset, bounds.size.width, bounds.size.height);
		
		textField.frame = frame;
		textField.font = self.textLabel.font;
		textField.text = [dataTarget valueForKey:dataKey];
		textField.hidden = NO;
		self.textLabel.hidden = YES;
		self.detailTextLabel.hidden = YES;
	} else {
		textField.hidden = YES;
		self.textLabel.text = [dataTarget valueForKey:dataKey];
		self.textLabel.hidden = NO;
		self.detailTextLabel.hidden = NO;
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state.
}

- (void)prepareForReuse {
	dataTarget = nil;
}

/**
 *	Why not do these things in doneWithKeyboard?  Because a user can stop editing in a couple of ways
 *	besides touching the "Done" key, like touching a different cell.  So, when a cell goes out of 
 *	editing mode we record the text changes.
 *
 *	By doing this before the state change instead of after, we avoid a slight flicker in the label text.
 */
- (void)willTransitionToState:(UITableViewCellStateMask)state {
	[super willTransitionToState:state];
	
	if (state ==  UITableViewCellSeparatorStyleNone) {
		NSObject *obj = dataTarget;
		// self.textLabel.text = textField.text;	// update the label to the value of our edited text
		[obj setValue:textField.text forKey:dataKey];	// update the model
		[self.textField resignFirstResponder];
	}
}

/**
 *	The user hit the 'done' button on the keyboard.  Dismiss the keyboard.
 */
- (void)doneWithKeyboard:(UITextField*)ctrl {
	[textField resignFirstResponder];
}

- (void)setTarget:(id)target withKey:(NSString*)key {
	dataTarget = target;
	dataKey = key;
	textField.placeholder = key;
}

@end
