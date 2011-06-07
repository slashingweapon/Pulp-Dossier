//
//  CAttributeImage.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/6/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAttribute.h"

@interface CAttributeImage : CAttribute {
	UIImage *imageValue;
}

@property (nonatomic,retain) UIImage *imageValue;

@end
