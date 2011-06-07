//
//  Character.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/7/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAttributeContainer.h"

#define CHARACTER_VERSION 1

@interface Character : CAttributeContainer {
	NSNumber *version;
}

@property (nonatomic,retain) NSNumber *version;

@end
