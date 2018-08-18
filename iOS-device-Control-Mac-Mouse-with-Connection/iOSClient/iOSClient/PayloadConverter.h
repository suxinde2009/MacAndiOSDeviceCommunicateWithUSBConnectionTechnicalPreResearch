//
//  PayloadConverter.h
//  iOSClient
//
//  Created by SuXinDe on 2018/8/18.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTExampleProtocol.h"
#import "PTChannel.h"

@interface PayloadConverter : NSObject

- (NSString *)convertToString:(PTData*) payload;

@end
