//
//  nvramutils.m
//  oibconfig
//
//  Created by Neonkoala on 03/05/2010.
//  Copyright 2010 yourcompany. All rights reserved.
//

#import "nvramutils.h"

@implementation nvramutils

-(int)nvramHook:(NSString *)filePath withArgs:(NSArray *)arguments withMode:(int)rorw
{
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	BOOL run = NO;
	
	if(rorw==0 && !fileExists){
		run = YES;
	}else if(rorw==1 && fileExists){
		run = YES;
	}
	
	if(run){	
		NSTask *hookNVRAM;
		hookNVRAM = [[NSTask alloc] init];
		[hookNVRAM setLaunchPath: @"/usr/sbin/nvram"];													//Set binary path

		[hookNVRAM setArguments: arguments];															//Set array of args

		NSPipe *hookNVRAMpipe;																			//Deal with output
		hookNVRAMpipe = [NSPipe pipe];
		[hookNVRAM setStandardOutput: hookNVRAMpipe];

		NSFileHandle *hookNVRAMfile;																	//Dumpfile for output
		hookNVRAMfile = [hookNVRAMpipe fileHandleForReading];

		[hookNVRAM launch];																				//GO!
		[hookNVRAM waitUntilExit];
		int status = [hookNVRAM terminationStatus];														//Check termination
		
		NSData *hookNVRAMdata;
		hookNVRAMdata = [hookNVRAMfile readDataToEndOfFile];
		
		NSString *string;
		string = [[NSString alloc] initWithData: hookNVRAMdata encoding: NSUTF8StringEncoding];
		
		if(rorw==0){
			NSError *error = [[NSError alloc] init];													//Dump output to file
			[string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
		}
		
		if (status==0) {																				//Check termination status of 'nvram'
			return 0;
		} else {
			return -2;
		}
	} else {
		return -1;
	}
}

-(int)nvramBackup:(BOOL)withOverwrite
{
	NSString *backupPath = @"/var/mobile/Documents/NVRAM.plist.backup";									//Set arbitary backup path
	NSArray *backupArgs;
	backupArgs = [NSArray arrayWithObjects: @"-x", @"-p", nil];											//Set flags for XML and dump
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:backupPath];						//Check if file has been backed up before
	
	if(withOverwrite && fileExists){																	//If file exists and overwrite flags set, delete it
		if ([[NSFileManager defaultManager] removeItemAtPath:backupPath error: NULL]  == YES) {
			NSLog(@"Removed old backup");
		} else {
			NSLog(@"Failed to remove old backup");
			return -1;																					//Return -1 if we couldn't
		}
	}
	
	fileExists = [[NSFileManager defaultManager] fileExistsAtPath:backupPath];							//Check file exists again or BOOL may be incorrect
	
	if(!fileExists){
		id mynvramutils;
		mynvramutils=[nvramutils new];
		
		int backupSuccess = [mynvramutils nvramHook:backupPath withArgs:backupArgs withMode:0];			//Call the nvram util hook
		
		if (backupSuccess==0) {
			return 0;																					//If dump was successful return 0
		} else {
			return -2;																					//Check if the hook failed
		}
	} else {
		return 1;																						//File existing not technically an error so return 1
	}
}

-(int)nvramDump:(NSString *)filePath
{
	NSArray *dumpArgs;
	dumpArgs = [NSArray arrayWithObjects: @"-x", @"-p", nil];											//Set flags for XML and dump
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];						//Check if file has been backed up before should be gone
	
	if(fileExists){																						//If file exists, delete it
		if ([[NSFileManager defaultManager] removeItemAtPath:filePath error: NULL]  == YES) {
			NSLog(@"Removed old working dump");
		} else {
			NSLog(@"Failed to remove dump");
			return -1;																					//Return -1 if we couldn't
		}
	}
	
	fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];							//Check file exists again or BOOL may be incorrect
	
	if(!fileExists){
		id mynvramutils;
		mynvramutils=[nvramutils new];
		
		int dumpSuccess = [mynvramutils nvramHook:filePath withArgs:dumpArgs withMode:0];				//Call the nvram util hook
		
		if (dumpSuccess==0) {
			return 0;																					//If dump was successful return 0
		} else {
			return -2;																					//Check if the hook failed
		}
	} else {
		return -1;																						//File existing is an error so return 1
	}
}

-(int)nvramWrite:(NSString *)filePath
{
	NSArray *updateArgs;
	updateArgs = [NSArray arrayWithObjects: @"-x", @"-f", filePath, nil];								//Set write mode args with xml
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];						
	
	if(fileExists){
		id mynvramutils;
		mynvramutils=[nvramutils new];
		
		int writeSuccess = [mynvramutils nvramHook:filePath withArgs:updateArgs withMode:1];
	
		if (writeSuccess==0) {
			return 0;																					//If dump was successful return 0
		} else {
			return -1;																					//Check if the hook failed
		}
	} else {
		return -2;
	}
}

-(int)nvramParse:(NSString *)filePath
{
	NSMutableDictionary *nvramDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	NSLog(@"%@", nvramDict);

	if (![nvramDict objectForKey:@"platform-uuid"]) {
		NSLog(@"Failed to get UUID.");
		return -1;
	}
	if (![nvramDict objectForKey:@"opib-version"]) {													//Check openiboot is installed before we go any further
		NSLog(@"Failed to get opib-version.");
		return -2;
	}
	
	if (![nvramDict objectForKey:@"opib-menu-timeout"] || ![nvramDict objectForKey:@"opib-default-os"] || ![nvramDict objectForKey:@"opib-auto-boot"]) {
		return -3;
	}
	
	NSData *rawVersion = [nvramDict objectForKey:@"opib-version"];
	NSString *version = [NSString stringWithCString:[rawVersion bytes] encoding:NSUTF8StringEncoding];
	NSData *rawTimeout = [nvramDict objectForKey:@"opib-menu-timeout"];
	NSString *timeout = [NSString stringWithCString:[rawTimeout bytes] encoding:NSUTF8StringEncoding];
	NSData *rawDefaultOs = [nvramDict objectForKey:@"opib-default-os"];
	NSString *defaultOs = [NSString stringWithCString:[rawDefaultOs bytes] encoding:NSUTF8StringEncoding];
	NSData *rawAutoBoot = [nvramDict objectForKey:@"opib-auto-boot"];
	NSString *autoBoot = [NSString stringWithCString:[rawAutoBoot bytes] encoding:NSUTF8StringEncoding];
	
	dataclass *thisconfig = [dataclass nvramconfig];
	
	thisconfig.opibVersion = version;
	thisconfig.opibTimeout = timeout;
	thisconfig.opibDefaultOs = defaultOs;
	thisconfig.opibAutoBoot = autoBoot;
	
	return 0;
}

-(int)nvramGenerate:(NSString *)filePath
{
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	
	if(!fileExists) {
		return -1;
	}
	
	NSMutableDictionary* nvramDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	dataclass *thisconfig = [dataclass nvramconfig];
	
	NSData *rawTimeout = [thisconfig.opibTimeout dataUsingEncoding:NSUTF8StringEncoding];				//Convert utf8 into raw binary
	NSData *rawDefaultOs = [thisconfig.opibDefaultOs dataUsingEncoding:NSUTF8StringEncoding];
	NSData *rawAutoBoot = [thisconfig.opibAutoBoot dataUsingEncoding:NSUTF8StringEncoding];
	
	if (rawTimeout!=nil && rawDefaultOs!=nil && rawAutoBoot!=nil) {										//Check for data
		[nvramDict setObject:rawTimeout forKey:@"opib-menu-timeout"];
		[nvramDict setObject:rawDefaultOs forKey:@"opib-default-os"];
		[nvramDict setObject:rawAutoBoot forKey:@"opib-auto-boot"];	
	} else {
		return -2;																						//Return -2 if null values
	}
	
	if([[NSFileManager defaultManager] removeItemAtPath:filePath error: NULL]  == YES) {										//Remove old plist
		NSLog(@"Removed old working dump");
		[nvramDict writeToFile:filePath atomically:YES];												//Write new one
	} else {
		NSLog(@"Failed to remove dump");
		return -3;																						//Return -3 if we couldn't
	}
	
	fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];							//Check for new plist
	
	if(fileExists){
		return 0;
	} else {
		return -4;
	}
}

-(int)nvramInit
{																										//Initialisation routine for program launch
	NSString *filePath = @"/var/mobile/Documents/NVRAM.plist";
	id mynvramutils;
	mynvramutils=[nvramutils new];
	
	int backup = [mynvramutils nvramBackup:NO];
	
	if (backup<0) {
		NSLog(@"NVRAM Backup failed.");
		return -1;
	}
	
	int getnew = [mynvramutils nvramDump:filePath];
	
	if (getnew!=0) {
		NSLog(@"Failed to obtain working copy of NVRAM.");
		return -2;
	}
	
	int parsed = [mynvramutils nvramParse:filePath];
	
	if (parsed==-1) {
		NSLog(@"NVRAM configuration corrupt or invalid.");
		return -3;
	} else if (parsed==-2) {
		NSLog(@"Openiboot not installed. Aborting.");
		return -4;
	} else if (parsed==-3) {
		NSLog(@"NVRAM configuration is corrupt. Aborting.");
		return -5;
	} else if (parsed!=0) {
		NSLog(@"Failed to parse NVRAM dump.");
		return -6;
	}
	
	return 0;
}
-(int)nvramReset
{
	id mynvramutils;
	mynvramutils=[nvramutils new];
	dataclass *thisconfig = [dataclass nvramconfig];

	thisconfig.opibTimeout = @"10000";
	thisconfig.opibDefaultOs = @"0";
	thisconfig.opibAutoBoot = @"0";
	
	NSString* resetPath = @"/var/mobile/Documents/NVRAM.plist";
	
	int generated = [mynvramutils nvramGenerate:resetPath];
	int updated;
	
	if(generated==0){
		updated = [mynvramutils nvramWrite:resetPath];
	} else {
		UIAlertView *resetResults;
		resetResults = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to reset NVRAM configuration." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[resetResults setTag:10];
		[resetResults show];
		[resetResults release];
	}
	if(updated==0){
		[mynvramutils nvramInit];
	} else {
		UIAlertView *resetResults;
		resetResults = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to reset NVRAM configuration." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[resetResults setTag:10];
		[resetResults show];
		[resetResults release];
	}
	return 0;
}

@end
