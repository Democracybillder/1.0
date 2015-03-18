#import "Request.h"

static NSString *const kNumAdditionalBillsKey = @"numAdditionalBills";

@implementation Request

- (NSData *)dataValue {
  NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionary];
  NSNumber *numAdditionalBillsObject = [NSNumber numberWithUnsignedInteger:self.numAdditionalBills];
  [jsonDictionary setObject:numAdditionalBillsObject forKey:kNumAdditionalBillsKey];

  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&error];

  if (!jsonData) {
    NSLog(@"Error converting json to data: %@", error.localizedDescription);
    return nil;
  } else {
    return jsonData;
  }
}

@end
