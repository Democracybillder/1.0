#import "ImageFetcher.h"

@implementation ImageFetcher

+ (void)fetchImageWithURL:(NSURL *)url
          completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           if (!error) {
                             UIImage *image = [[UIImage alloc] initWithData:data];
                             completionBlock(YES,image);
                           } else {
                             completionBlock(NO,nil);
                           }
                         }];
}

@end
