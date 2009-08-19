//
//  JFDataCache.m
//  SCSApp
//
//  Created by John Fricker on 5/30/09.
//  Copyright 2009 John Fricker Software Development. All rights reserved.
//
// In memory cache first
//

#import "JFDataCache.h"


@implementation JFDataCache

-(id)init {
	if (self = [super init]) {
		cache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void)dealloc {
	[super dealloc];
	[cache release];
}

+(JFDataCache *)dataCacheInstance {
	static JFDataCache *instance;
	@synchronized(self) {
		if (!instance) {
			instance = [[JFDataCache alloc] init];
		}
	}
	return instance;
}


-(id)getCachedItem:(NSString *)key {
	NSObject *object = nil;
	object = [cache objectForKey:key];
	return object;
}

-(NSData *)getCachedData:(NSString *)key {
	NSData *object = nil;
	//NSLog(@"getting data for key %@", key);
	object = [cache objectForKey:key];
	return object;
}

-(BOOL)dataInCache:(NSString *)key {
	return (nil != [cache objectForKey:key]);
}

-(void)saveItemToCache:(NSObject *)item forKey:(NSString *)key {
	//NSLog(@"caching item for key %@ : count %d", key, [cache count]);
	[cache setObject:item forKey:key];
}

-(void)saveDataToCache:(NSData *)item forKey:(NSString *)key {
	//NSLog(@"caching data for key %@ : count %d", key, [cache count]);
	[cache setObject:item forKey:key];
}

@end
