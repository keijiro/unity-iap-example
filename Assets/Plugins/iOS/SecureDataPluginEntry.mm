#import <Foundation/Foundation.h>
#import "SecureData.h"

#pragma mark - Utility Function

static NSString* CreateNSString (const char* string) {
    return [NSString stringWithUTF8String:(string ? string : "")];
}

static char* MakeHeapString(const char* string) {
    if (!string) return NULL;
    char* mem = static_cast<char*>(malloc(strlen(string) + 1));
    if (mem) strcpy(mem, string);
    return mem;
}

#pragma mark Plug-in Function

extern "C" bool _SecureDataGetBool(const char *key) {
    NSNumber *number = [[SecureData sharedInstance].dict objectForKey:CreateNSString(key)];
    return number.boolValue;
}

extern "C" int _SecureDataGetInt(const char *key) {
    NSNumber *number = [[SecureData sharedInstance].dict objectForKey:CreateNSString(key)];
    return number.intValue;
}

extern "C" float _SecureDataGetFloat(const char *key) {
    NSNumber *number = [[SecureData sharedInstance].dict objectForKey:CreateNSString(key)];
    return number.floatValue;
}

extern "C" const char * _SecureDataGetString(const char *key) {
    NSString *string = [[SecureData sharedInstance].dict objectForKey:CreateNSString(key)];
    return MakeHeapString(string.UTF8String);
}

extern "C" void _SecureDataSetBool(const char *key, bool value) {
    [[SecureData sharedInstance].dict setObject:[NSNumber numberWithBool:value] forKey:CreateNSString(key)];
}

extern "C" void _SecureDataSetInt(const char *key, int value) {
    [[SecureData sharedInstance].dict setObject:[NSNumber numberWithInt:value] forKey:CreateNSString(key)];
}

extern "C" void _SecureDataSetFloat(const char *key, float value) {
    [[SecureData sharedInstance].dict setObject:[NSNumber numberWithFloat:value] forKey:CreateNSString(key)];
}

extern "C" void _SecureDataSetString(const char *key, const char *value) {
    [[SecureData sharedInstance].dict setObject:CreateNSString(value) forKey:CreateNSString(key)];
}

extern "C" void _SecureDataFlush() {
    [[SecureData sharedInstance] store];
}
