//
//  oibconfigAppDelegate.m
//  oibconfig
//
//  Created by Neonkoala on 02/05/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "oibconfigAppDelegate.h"
#import "oibconfigViewController.h"

@implementation oibconfigAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// Override point for customization after app launch
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
