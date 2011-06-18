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
		textField.font = [UIFont systemFontOfSize:17];
		textField.minimumFontSize = 8;
		
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

/**
 *	The technique here is to let the superclass do all the math for us.  Then we just hide the detailTextLabel,
 *	and steal its frame, font size, color, etc. for our textField object.
 */
- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect labelRect = self.textLabel.frame;
	CGRect contentBounds = self.contentView.bounds;
	CGSize exSize = [@"X" sizeWithFont:textField.font forWidth:contentBounds.size.width lineBreakMode:UILineBreakModeTailTruncation];
	
	CGRect fieldRect = CGRectMake(
								  (labelRect.origin.x * 2) + labelRect.size.width,
								  (contentBounds.size.height - exSize.height) / 2,
								  contentBounds.size.width - (labelRect.origin.x * 3) - labelRect.size.width,
								  exSize.height
	);
	
	textField.frame = fieldRect;
	textField.textAlignment = UITextAlignmentLeft;
	textField.text = [dataTarget valueForKey:dataKey];

	self.detailTextLabel.hidden = YES;
	
	if (self.editing)
		textField.enabled = YES;
	else
		textField.enabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {    
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state.
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	; // we explicitly do nothing here, because we're driving the text changes
}

@end
