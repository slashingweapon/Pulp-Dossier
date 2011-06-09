//
//  CAttributeLadder.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/8/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAttribute.h"

@interface CAttributeLadder : CAttribute {
	NSNumber *levelValue;
}

@property (nonatomic, retain) NSNumber *levelValue;

+ (NSString*) stringForLevel:(NSNumber*)level;

// Returns a string array for the entire ladder, from best rank to worst.
+ (NSArray*) allLevelStrings;

@end
