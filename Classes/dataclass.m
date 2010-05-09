//
//  dataclass.m
//  oibconfig
//
//  Created by Neonkoala on 09/05/2010.
//  Copyright 2010 yourcompany. All rights reserved.
//

#import "dataclass.h"

static dataclass *nvramconfig = nil;

@implementation dataclass

@synthesize timeout;
@synthesize defaultos;
@synthesize autoboot;

#pragma mark Singleton Methods
+ (id)nvramconfig {
	@synchronized(self) {
		if(nvramconfig == nil)
			[[self alloc] init];
	}
	return nvramconfig;
}
+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(nvramconfig == nil)  {
			nvramconfig = [super allocWithZone:zone];
			return nvramconfig;
		}
	}
	return nil;
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)retain {
	return self;
}
- (unsigned)retainCount {
	return UINT_MAX; //denotes an object that cannot be released
}
- (void)release {
	// never release
}
- (id)autorelease {
	return self;
}
- (id)init {
	if (self = [super init]) {
		timeout = [[NSString  alloc] initWithString:@""];
		defaultos = [[NSString  alloc] initWithString:@""];
		autoboot = [[NSString alloc] initWithString:@""];
	}
	return nil;
}
- (void)dealloc {
	[timeout release];
	[defaultos release];
	[autoboot release];
	[super dealloc];
}

@end