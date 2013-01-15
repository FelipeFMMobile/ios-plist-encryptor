//
//  FMPlistEn.m
//  iooioo-prot
//
//  Created by Felipe Menezes on 22/11/12.
//  Copyright (c) 2012 Felipe Menezes. All rights reserved.
//

#import "FMPlistEn.h"

#import "FBEncryptorAES.h"

@implementation FMPlistEn

#define SECRET_PASSWOD @"YOUR_KEY"

+(NSString *)encryptBase64AESString:(NSString *)string {
   // NSData *encryptedData = [data AESEncryptWithPassphrase:SECRET_PASSWOD];
    //[Base64 initialize];
    NSString * result = [FBEncryptorAES encryptBase64String:string
                              keyString:SECRET_PASSWOD
                          separateLines:NO];
	return result;
}
+(NSString *)dencryptStringFromBase64AESString:(NSString *)string {

   // NSData	*b64DecData = [Base64 decode:string];
    //return [b64DecData AESDecryptWithPassphrase:SECRET_PASSWOD];
    return [FBEncryptorAES decryptBase64String:string
                              keyString:SECRET_PASSWOD];
}
// encrypt for Array
+(NSArray *) encryptArray : (NSArray *) array {
    NSMutableArray * result = [[NSMutableArray alloc] init];

    int total=[array count];
    for (int i=0;i<total;i++) {
        id newobj;
        id obj = [array objectAtIndex:i];
         if ([obj isKindOfClass:[NSDictionary class]]) {
             newobj=[FMPlistEn encryptDictionary:obj];
         }
        if ([obj isKindOfClass:[NSArray class]]) {
            // Recurive call to encrypt array
             newobj=[FMPlistEn encryptArray:obj];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            newobj=[FMPlistEn encryptBase64AESString:obj];
        }
        [result addObject:newobj];
        
    }
    return result;
 }
// encrypt to Dictionary
+(NSDictionary *) encryptDictionary : (NSDictionary *) dict {
    NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
    NSArray * keys = [dict allKeys];
    for (NSString * key in keys) {
        id newobj;
        id obj = [dict valueForKey:key];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            // Recurive call to encrypt dictionary
            newobj = [FMPlistEn encryptDictionary:obj];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            newobj=[FMPlistEn encryptArray:obj];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            newobj=[FMPlistEn encryptBase64AESString:obj];
        }
        [result setValue:newobj forKey:[FMPlistEn encryptBase64AESString:key]];
    }
    return result;
}


// DECRYPT PROCESS
// dencrypt for Array
+(NSArray *) dencryptArray : (NSArray *) array {
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    int total=[array count];
    for (int i=0;i<total;i++) {
        id newobj;
        id obj = [array objectAtIndex:i];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            newobj=[FMPlistEn dencryptDictionary:obj];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            // Recurive call to encrypt array
            newobj=[FMPlistEn dencryptArray:obj];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            newobj=[FMPlistEn dencryptStringFromBase64AESString:obj];
        }
        [result addObject:newobj];
        
    }
    return result;
}
// dencrypt to Dictionary
+(NSDictionary *) dencryptDictionary : (NSDictionary *) dict {
    NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
    NSArray * keys = [dict allKeys];
    for (NSString * key in keys) {
        id newobj;
        id obj = [dict valueForKey:key];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            // Recurive call to encrypt dictionary
            newobj = [FMPlistEn dencryptDictionary:obj];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            newobj=[FMPlistEn dencryptArray:obj];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            newobj=[FMPlistEn dencryptStringFromBase64AESString:obj];
        }
        [result setValue:newobj forKey:[FMPlistEn dencryptStringFromBase64AESString:key]];
    }
    return result;
}







+(NSString *) buildEncryptedPlist:(NSArray *)plistArray {
    
    NSString * newplist = [NSMutableString stringWithString:@"<plist version='1.0'>"];
     newplist=[newplist stringByAppendingString:[FMPlistEn composeArrayPlist:plistArray]];
    newplist=[newplist stringByAppendingString:@"</plist>"];
    return newplist;
    
    
    
}
+(NSString *)composeArrayPlist:(NSArray *)array {
    
    NSString * compose = @"";
    int total=[array count];
    compose=[compose stringByAppendingString:@"<array>"];
    for (int i=0;i<total;i++) {
        id obj = [array objectAtIndex:i];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            compose=[compose stringByAppendingString:[FMPlistEn composeDictPlist:obj]];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            // Recurive call to encrypt array
             compose=[compose stringByAppendingString:[FMPlistEn composeArrayPlist:obj]];
        }
        if ([obj isKindOfClass:[NSString class]]) {
           compose=[compose stringByAppendingString:@"<string>"];
           compose=[compose stringByAppendingString:obj];
           compose=[compose stringByAppendingString:@"</string>"];
        }
    }
    compose=[compose stringByAppendingString:@"</array>"];
    return compose;
}

+(NSString *)composeDictPlist:(NSDictionary *)dict {
    NSString * compose = @"";
    NSArray * keys = [dict allKeys];
     compose=[compose stringByAppendingString:@"<dict>"];
    for (NSString * key in keys) {
      compose=[compose stringByAppendingString:@"<key>"];
      compose=[compose stringByAppendingString:key];
      compose=[compose stringByAppendingString:@"</key>"];
        id obj = [dict valueForKey:key];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            // Recurive call to encrypt dictionary
              compose=[compose stringByAppendingString:[FMPlistEn composeDictPlist:obj]];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
             compose=[compose stringByAppendingString:[FMPlistEn composeArrayPlist:obj]];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            compose=[compose stringByAppendingString:@"<string>"];
            compose=[compose stringByAppendingString:obj];
            compose=[compose stringByAppendingString:@"</string>"];

        }
    }
    compose=[compose stringByAppendingString:@"</dict>"];
    return compose;
}

    
    
    
    
    
    

@end
