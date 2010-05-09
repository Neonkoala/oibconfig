//
//  datastore.h
//  oibconfig
//
//  Created by Neonkoala on 08/05/2010.
//  Copyright 2010 yourcompany. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface datastore : NSObject {
	NSMutableArray* newnvramconfig;
}

+(datastore*) nvramconfig;

@end