//
//  CAttributeString.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/6/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAttribute.h"

/*	Attributes for short text strings.
 
 */
@interface CAttributeInteger : CAttribute {
	NSNumber* integerValue;
}

@property (nonatomic, retain) NSNumber* integerValue;

// this is just temporary
- (NSString*)getStringValue;

@end
