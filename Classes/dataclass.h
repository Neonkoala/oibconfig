//
//  dataclass.h
//  oibconfig
//
//  Created by Neonkoala on 09/05/2010.
//  Copyright 2010 yourcompany. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface dataclass : NSObject {
	NSString *opibVersion;
	NSString *opibTimeout;
	NSString *opibDefaultOs;
	NSString *opibAutoBoot;
}

@property (nonatomic, retain) NSString *opibVersion;
@property (nonatomic, retain) NSString *opibTimeout;
@property (nonatomic, retain) NSString *opibDefaultOs;
@property (nonatomic, retain) NSString *opibAutoBoot;

+ (id)nvramconfig;

@end