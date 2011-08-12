#import <Foundation/Foundation.h>

@interface SecureData : NSObject;

@property (nonatomic, retain) NSMutableDictionary *dict;

- (void)store;
- (void)retrieve;

+ (SecureData *)sharedInstance;

@end
