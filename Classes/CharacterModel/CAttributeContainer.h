//
//  CAttributeContainer.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/6/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAttribute.h"

/*	Characters and all kinds of resources (aspects, skills, etc) are all 
	attribute containers, obviously because they "have" attributes.  When
	appropriate, we want the attributes to behave like properties, and we
	also want to be able to access the attributes property like the array
	that it is.
 
	This class is mainly just about the key-value coding required to support
	the syntactical sugar at the higher levels of code, and to get all of the
	other goodness that KV-compliant coding gives us (observability, etc).
 */
@interface CAttributeContainer : NSObject <NSCoding> {
	NSMutableArray *attributes;
}

@property (nonatomic,retain) NSMutableArray *attributes;

@end
