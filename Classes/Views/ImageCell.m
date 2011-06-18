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
		picture = [[[UIImageView alloc] initWithImage:nil] autorelease];
		[self.contentView addSubview:picture];
		
		self.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect labelRect = self.textLabel.frame;
	CGRect contentBounds = self.contentView.bounds;
	
	CGRect buttonRect = CGRectMake(
								   (labelRect.origin.x * 2) + labelRect.size.width,
								   contentBounds.origin.y,
								   contentBounds.size.height,
								   contentBounds.size.height
								   );
	
	picture.frame = buttonRect;
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
		picture.image = newImage;		
		[self setNeedsLayout];
	} else {
		picture.image = [UIImage imageNamed:@"Icon.png"];
	}
}

@end
