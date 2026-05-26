#import <UIKit/UIKit.h>

// Hook 解密函数，替换 IP
%hookf(NSString*, _GRNDecodeObfuscatedString, void *cipher, NSUInteger length, char key) {
    NSString *result = %orig(cipher, length, key);
    
    // 替换原 IP
    if ([result containsString:@"154.222.16.236"]) {
        NSString *newResult = [result stringByReplacingOccurrencesOfString:@"154.222.16.236"
                                                                 withString:@"43.139.221.5"];
        NSLog(@"[Bypass] IP: %@ -> %@", result, newResult);
        return newResult;
    }
    
    // 替换端口
    if ([result containsString:@":88"]) {
        NSString *newResult = [result stringByReplacingOccurrencesOfString:@":88"
                                                                 withString:@":8989"];
        return newResult;
    }
    
    return result;
}

// 绕过完整性检查
%hook GRNSelfIntegrityGuard
+ (NSArray *)functionPrologueViolationReasons { return @[]; }
+ (NSString *)dylibIntegrityViolationReason { return nil; }
+ (BOOL)verifyDylibTextSegmentIntegrity { return YES; }
%end

%hook GRNFunctionHashGuard
+ (NSArray *)integrityViolationReasons { return @[]; }
+ (BOOL)isExpectedImagePath:(NSString *)path forSymbol:(NSString *)symbol { return YES; }
%end

%hook GRNLicenseGuard
+ (BOOL)isBypassEnabled { return YES; }
+ (BOOL)evaluateTrialWithReason:(id)reason { return YES; }
%end

%hook GRNSecurityGuard
+ (BOOL)isGuardDisabled { return YES; }
%end

%hook GRNActivationManager
- (BOOL)isActivated { return YES; }
- (BOOL)ensureActivatedOrPresent { return YES; }
%end

%ctor {
    NSLog(@"[Bypass] GRN Bypass Loaded");
}