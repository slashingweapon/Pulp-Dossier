//
//  ImageCell.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/7/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "ImageCell.h"
#import "PickAnImageController.h"

@implementation ImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
		imageButton.enabled = NO;
		[imageButton addTarget:self 
						action:@selector(pickImage:)
			  forControlEvents:UIControlEventTouchUpInside];

		[self.contentView addSubview:imageButton];
		self.detailTextLabel.hidden = YES;
		self.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	if (imageBackground == nil) {
		imageBackground = [UIImage imageNamed:@"Icon.png"];
		[imageButton setBackgroundImage:imageBackground forState:UIControlStateNormal];
	}
	
	CGRect labelRect = self.textLabel.frame;
	CGRect contentBounds = self.contentView.bounds;
	
	CGRect buttonRect = CGRectMake(
								   (labelRect.origin.x * 2) + labelRect.size.width,
								   contentBounds.origin.y,
								   contentBounds.size.height,
								   contentBounds.size.height
								   );
	
	imageButton.frame = buttonRect;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];

	if (editing)
		imageButton.enabled = YES;
	else
		imageButton.enabled = NO;
}

- (void)setTarget:(id)target withKey:(NSString*)key {
	// unregister any old observers
	if (dataTarget)
		[dataTarget removeObserver:self forKeyPath:dataKey];
	
	[super setTarget:target withKey:key];
	
	// register as an observer of our target object
	if (dataTarget) {
		[dataTarget addObserver:self 
				 forKeyPath:key 
					options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial 
					context:nil];
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	UIImage *newImage = [change valueForKey:NSKeyValueChangeNewKey];
	if ([newImage isKindOfClass:[UIImage class]]) {
		imageBackground = newImage;
		[imageButton setBackgroundImage:newImage forState:UIControlStateNormal];
		[self setNeedsLayout];
	}
}

- (IBAction)pickImage:(id)sender {
	if (self.editing && self.controller) {
		PickAnImageController *picker = [[[PickAnImageController alloc] initWithNibName:nil bundle:nil] autorelease];
		picker.target = dataTarget;
		picker.key = dataKey;
		
		[self.controller presentModalViewController:picker animated:YES];
	}
}

@end
