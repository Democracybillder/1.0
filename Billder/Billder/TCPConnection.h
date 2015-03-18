#import <Foundation/Foundation.h>

@class BillRequest;

@interface TCPConnection : NSObject <NSStreamDelegate>

+ (instancetype)connectionWithRequest:(NSString *)request
                           completion:(void (^)(NSDictionary *response, NSError *error))completion;
- (void)connect;
- (void)disconnect;

@end
