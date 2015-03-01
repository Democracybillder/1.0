#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ImageFetcher : NSObject

+ (void)fetchImageWithURL:(NSURL *)url
          completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

@end
