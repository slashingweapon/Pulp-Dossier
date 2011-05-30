//
//  Pulp_DossierAppDelegate.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 5/29/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Pulp_DossierAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

