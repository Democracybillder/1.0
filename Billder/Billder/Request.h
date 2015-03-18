#import <Foundation/Foundation.h>

@interface Request : NSObject

@property(nonatomic) NSUInteger numAdditionalBills;

- (NSData *)dataValue;

@end
