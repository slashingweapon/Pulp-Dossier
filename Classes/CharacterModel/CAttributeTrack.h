//
//  CAttributeTrack.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/10/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAttribute.h"

@interface CAttributeTrack : CAttribute {
	NSNumber *maximum;
	NSNumber *track;
	NSMutableArray *consequences;
	NSString *stringEquivalent;
}

@property (nonatomic, retain) NSNumber *maximum;
@property (nonatomic, retain) NSNumber *track;
@property (nonatomic, retain) NSMutableArray *consequences;
@property (nonatomic, retain) NSString *stringEquivalent;

- (void)observeSelf;
- (void)unobserveSelf;

@end
