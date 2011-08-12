#import "SecureData.h"

#define kServiceName @"UnitySecureData"

@implementation SecureData

@synthesize dict = dict_;

#pragma mark - Object Lifecycle

- (id)init {
    if ((self = [super init])) {
        [self retrieve];
    }
    return self;
}

- (void)dealloc {
    self.dict = nil;
    [super dealloc];
}

#pragma mark - Transaction Method

- (void)store {
    NSMutableDictionary *secItem = [[[NSMutableDictionary alloc] init] autorelease];
    [secItem setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [secItem setObject:kServiceName forKey:(id)kSecAttrService];
    
    SecItemDelete((CFDictionaryRef)secItem);
    [secItem setObject:[NSKeyedArchiver archivedDataWithRootObject:self.dict] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)secItem, NULL);
}

- (void)retrieve {
    self.dict = nil;
    
    NSMutableDictionary *secItem = [[NSMutableDictionary alloc] init];
    [secItem setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [secItem setObject:kServiceName forKey:(id)kSecAttrService];
    [secItem setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [secItem setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    NSData *data = nil;
    if (SecItemCopyMatching((CFDictionaryRef)secItem, (CFTypeRef *)&data) == errSecSuccess) {
        self.dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    [data release];
    
    if (!self.dict) self.dict = [NSMutableDictionary dictionary];
}

#pragma mark - Class Function

static SecureData *s_instance;

+ (SecureData *)sharedInstance {
    if (s_instance == nil) {
        s_instance = [[SecureData alloc] init];
    }
    return s_instance;
}

@end
