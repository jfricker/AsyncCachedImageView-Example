//
//  JFDataCache.h
//  SCSApp
//
//  Created by John Fricker on 5/30/09.
//  Copyright 2009 John Fricker Software Development. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JFDataCache : NSObject {
	NSMutableDictionary *cache;
}

-(BOOL)dataInCache:(NSString *)key;
-(id)getCachedItem:(NSString *)key;
-(NSData *)getCachedData:(NSString *)key;
-(void)saveItemToCache:(NSObject *)item forKey:(NSString *)key;
-(void)saveDataToCache:(NSData *)item forKey:(NSString *)key;
+(JFDataCache *)dataCacheInstance;
@end
