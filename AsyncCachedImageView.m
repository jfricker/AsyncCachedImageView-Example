//
//  AsyncImageView.m
//  SCSApp
//
//  Created by John Fricker on 5/2/09.
//  Copyright 2009 John Fricker Software Development. All rights reserved.
//


#import "AsyncCachedImageView.h"
#import "JFDataCache.h"

@implementation AsyncCachedImageView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		cache = [JFDataCache dataCacheInstance];
	}
	return self;
}

- (void)dealloc {
	[connection cancel];
	[connection release];
	[data release]; 
    [super dealloc];
}


- (void)loadImageFromURL:(NSURL*)url {
	if (connection!=nil) { [connection release]; }
	if (data!=nil) { [data release]; }
	urlImg = url;
	if ([cache dataInCache:[url absoluteString]]) {
		data = [NSMutableData dataWithData:[cache getCachedData:[urlImg absoluteString]]];
		[self displayImage];
	} else {
		if ([[urlImg absoluteString] length] > 0) {
			[self startAnimation];
			NSURLRequest* request = [NSURLRequest requestWithURL:urlImg cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0];
			connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
			if (connection == nil)
				NSLog(@"AsyncCachedImageView connection failed");
		}
	}
}

- (void)loadImageFromURL:(NSURL*)url withDefault:(NSString *)defaultImageName {
	_defaultImageName = defaultImageName;
	[self displayDefaultImage];
	[self loadImageFromURL:url];
}

- (void)loadImageFromData:(NSData *)dataImage {
	if (connection!=nil) { [connection release]; }
	if (data!=nil) { [data release]; }
	data = [NSData dataWithData:dataImage];
	[self displayImage];
}

//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data==nil) { data = [[NSMutableData alloc] initWithCapacity:2048]; } 
	[data appendData:incrementalData];
}

#define kDefault 1
#define kRealImage 2

//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	//so self data now has the complete image 
	[connection release];
	connection=nil;
	UIImageView *imageView = (UIImageView *)[self viewWithTag:kRealImage];
	[imageView removeFromSuperview];
	[cache saveDataToCache:data forKey:[urlImg absoluteString]];
	[self displayImage];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection error %@ :: %@", [error description], [urlImg absoluteString]);
	[self stopAnimation];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSHTTPURLResponse *reps = (NSHTTPURLResponse *)response;
	httpStatus = [reps statusCode];
	//NSLog(@"connection status code %d :: %@", httpStatus, [urlImg absoluteString]);
}

- (void)displayDefaultImage {
	UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:_defaultImageName]] autorelease];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
	[self addSubview:imageView];
	imageView.frame = self.bounds;
	imageView.tag = kDefault;
	[imageView setNeedsLayout];
	[self setNeedsLayout];
}

- (void)removeDefaultImage {
	UIImageView *imageView = (UIImageView *)[self viewWithTag:kDefault];
	[imageView removeFromSuperview];
}
	
- (void)displayImage {
	//make an image view for the image
	if (httpStatus < 300) {
		[self removeDefaultImage];
		UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageWithData:data]] autorelease];
		imageView.tag = kRealImage;
		//make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
		[self addSubview:imageView];
		imageView.frame = self.bounds;
		[imageView setNeedsLayout];
		[self setNeedsLayout];
	}
	//[data release]; //don't need this any more, its in the UIImageView now
	data=nil;
	[self stopAnimation];
}

//just in case you want to get the image directly, here it is in subviews
- (UIImage*) image {
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	return [iv image];
}


/* show the user that loading activity has started */

- (void) startAnimation {
//	[self.activityIndicator startAnimating];
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = YES;
}


/* show the user that loading activity has stopped */

- (void) stopAnimation {
//	[self.activityIndicator stopAnimating];
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = NO;
}

@end
