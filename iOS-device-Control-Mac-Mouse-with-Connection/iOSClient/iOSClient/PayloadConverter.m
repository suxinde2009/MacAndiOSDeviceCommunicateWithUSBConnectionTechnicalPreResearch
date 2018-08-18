//
//  PayloadConverter.m
//  iOSClient
//
//  Created by SuXinDe on 2018/8/18.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import "PayloadConverter.h"

@implementation PayloadConverter

- (NSString *)convertToString:(PTData*)payload {
    PTExampleTextFrame *textFrame = (PTExampleTextFrame*)payload.data;
    textFrame->length = ntohl(textFrame->length);
    NSString *message = [[NSString alloc] initWithBytes:textFrame->utf8text
                                                 length:textFrame->length
                                               encoding:NSUTF8StringEncoding];
    
    return message;
}

@end
