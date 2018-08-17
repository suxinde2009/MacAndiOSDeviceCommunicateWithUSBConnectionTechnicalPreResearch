#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "PTChannel.h"
#import "PTProtocol.h"
#import "PTUSBHub.h"

FOUNDATION_EXPORT double PeerTalkVersionNumber;
FOUNDATION_EXPORT const unsigned char PeerTalkVersionString[];

