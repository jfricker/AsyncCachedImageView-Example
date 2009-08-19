//
//  AsyncImageView.h
//  SCSApp
//
//  Created by John Fricker on 5/2/09.
//  Copyright 2009 John Fricker Software Development. All rights reserved.
//


#import <UIKit/UIKit.h>

@class JFDataCache;

@interface AsyncCachedImageView : UIView {
	//could instead be a subclass of UIImageView instead of UIView, depending on what other features you want to 
	// to build into this class?

	NSURL *urlImg; // for the cache
	NSString *_defaultImageName; // placeholder for images
	NSURLConnection *connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData *data; //keep reference to the data so we can collect it as it downloads
	NSInteger httpStatus;
	JFDataCache *cache;
}

- (void)loadImageFromURL:(NSURL*)url;
- (void)loadImageFromURL:(NSURL*)url withDefault:(NSString *)defaultImageName;
- (void)loadImageFromData:(NSData *)dataImage;
- (void)displayDefaultImage;
- (void)removeDefaultImage;
- (void)displayImage;
- (UIImage*) image;
- (void) stopAnimation;
- (void) startAnimation;
@end
