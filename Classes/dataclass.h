//
//  dataclass.h
//  oibconfig
//
//  Created by Neonkoala on 09/05/2010.
//  Copyright 2010 yourcompany. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface dataclass : NSObject {
	NSString *timeout;
	NSString *defaultos;
	NSString *autoboot;
}

@property (nonatomic, retain) NSString *timeout;
@property (nonatomic, retain) NSString *defaultos;
@property (nonatomic, retain) NSString *autoboot;

+ (id)nvramconfig;

@end