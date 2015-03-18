#import <Foundation/Foundation.h>

@class Request;

@interface TCPConnection : NSObject <NSStreamDelegate>

+ (instancetype)connectionWithRequest:(Request *)request
                           completion:(void (^)(NSDictionary *response, NSError *error))completion;
- (void)connect;
- (void)disconnect;

@end
