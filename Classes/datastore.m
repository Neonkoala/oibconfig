//
//  datastore.m
//  oibconfig
//
//  Created by Neonkoala on 08/05/2010.
//  Copyright 2010 yourcompany. All rights reserved.
//

#import "datastore.h"

@implementation datastore
+(datastore*) nvramconfig
{
	static datastore *myInstance = nil;

    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
    }

    return myInstance;
}
	
@end
