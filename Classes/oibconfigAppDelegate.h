//
//  oibconfigAppDelegate.h
//  oibconfig
//
//  Created by Neonkoala on 02/05/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "nvramutils.h"
#import <UIKit/UIKit.h>


@class oibconfigViewController;

@interface oibconfigAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    oibconfigViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet oibconfigViewController *viewController;

@end

