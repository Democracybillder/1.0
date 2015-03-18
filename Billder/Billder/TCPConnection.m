#import "TCPConnection.h"

#import "DDLog.h"
#import "GCDAsyncSocket.h"
#import "NSString+Escaping.h"
#import "Request.h"

static NSString *const kHostName = @"localhost";
static const uint16_t kPort = 8080;
static const NSTimeInterval kTimeout = 30; // Kept low for testing. Should be increased for release.
static const NSUInteger kSizingBytes = 15;  // THIS MUST BE THE SAME VALUE AS IN THE SERVER.

@interface TCPConnection() <GCDAsyncSocketDelegate>

@property(nonatomic, strong) void (^completion)(NSDictionary *response, NSError *error);
@property(nonatomic) Request *request;
@property(nonatomic) GCDAsyncSocket *socket;
@property(nonatomic) NSInteger responseSize;

@end

@implementation TCPConnection {
  BOOL _completed;
}

+ (instancetype)connectionWithRequest:(Request *)request
                           completion:(void (^)(NSDictionary *response, NSError *error))completion {
  TCPConnection *connection = [[TCPConnection alloc] init];
  connection.socket = [[GCDAsyncSocket alloc] initWithDelegate:connection
                                                 delegateQueue:dispatch_get_main_queue()];
  connection.request = request;
  connection.completion = completion;
  connection.responseSize = -1;
  return connection;
}

- (void)dealloc {
  NSLog(@"TCP Connection dealloced");
  [self disconnect];
}

- (void)connect {
  NSError *error = nil;
  if (![self.socket connectToHost:kHostName onPort:kPort withTimeout:kTimeout error:&error]) {
    NSLog(@"Unable to connect to due to invalid configuration: %@", error);
    [self completeWithData:nil error:error];
  } else {
    NSLog(@"Connecting to \"%@\" on port %hu...", kHostName, kPort);
  }
}

- (void)disconnect {
  [self.socket setDelegate:nil];
  [self.socket disconnect];
  self.socket = nil;
}

- (void)socket:(GCDAsyncSocket *)socket didConnectToHost:(NSString *)host port:(uint16_t)port {
  NSLog(@"socket:%@didConnectToHost:%@ port:%hu", socket, host, port);

  NSData *requestData = [self.request dataValue];
  NSUInteger requestLength = [requestData length];
  NSString *requestLengthString = [NSString stringWithFormat:@"%lu", requestLength];

  while (requestLengthString.length < kSizingBytes) {
    requestLengthString = [@"0" stringByAppendingString:requestLengthString];
  }

  NSData *requestLengthData = [requestLengthString dataUsingEncoding:NSUTF8StringEncoding];
  NSMutableData *requestMutableData = [requestLengthData mutableCopy];
  [requestMutableData appendData:requestData];

  [socket writeData:requestMutableData withTimeout:kTimeout tag:0];
  NSLog(@"Sent socket %@ request %@", socket, [[NSString alloc] initWithData:requestMutableData
                                                                    encoding:NSUTF8StringEncoding]);

  [socket readDataToLength:kSizingBytes withTimeout:kTimeout tag:0];
}

- (void)socket:(GCDAsyncSocket *)socket didWriteDataWithTag:(long)tag {
  NSLog(@"Wrote data to socket:%@", socket);
}

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag {
  NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  NSLog(@"Read response for socket %@", socket);
  if (self.responseSize < 0) {
    NSString *lengthString = [response substringToIndex:kSizingBytes];
    self.responseSize = [lengthString integerValue];
    [socket readDataToLength:self.responseSize withTimeout:kTimeout tag:0];
  } else if (self.completion) {
    // Need to unescape unicode characters.
    [self completeWithData:data error:nil];
  }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)error {
  NSLog(@"Socket %@ disconnected with error: %@", socket, error);
  [self completeWithData:nil error:error];
}

- (void)completeWithData:(NSData *)data error:(NSError *)error {
  if (self.completion && !_completed) {
    _completed = YES;

    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&localError];
    if (localError != nil) {
      self.completion(nil, error);
    } else {
      self.completion(parsedObject, nil);
    }
  }
}

@end
