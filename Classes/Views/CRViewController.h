//
//  CRViewController.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/4/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CRViewController : UIViewController {
	id resource;
	NSArray *viewSpecs;
}

+(CRViewController*)hardInit:(id)targetResource;
- (id)initWithDefinition:(id)resourceSpec resource:(id)targetResource;

@end
