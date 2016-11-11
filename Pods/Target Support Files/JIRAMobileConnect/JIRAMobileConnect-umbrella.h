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

#import "JMC.h"
#import "JMCAttachmentItem.h"
#import "JMCCustomDataSource.h"
#import "JMCMacros.h"
#import "JMCViewController.h"
#import "JMCAttachmentsViewController.h"
#import "JMCConsoleLogReader.h"
#import "JMCLine.h"
#import "JMCShape.h"
#import "JMCShapeView.h"
#import "JMCSketch.h"
#import "JMCSketchContainerView.h"
#import "JMCSketchScrollView.h"
#import "JMCSketchView.h"
#import "JMCSketchViewController.h"
#import "JMCSketchViewControllerDelegate.h"
#import "JMCSketchViewControllerFactory.h"
#import "JMCVector.h"
#import "JMCVectorView.h"
#import "JMCCrashSender.h"
#import "JMCCrashTransport.h"
#import "JMCCreateIssueDelegate.h"
#import "JMCIssueTransport.h"
#import "JMCPing.h"
#import "JMCReplyDelegate.h"
#import "JMCReplyTransport.h"
#import "JMCTransport.h"
#import "JMCTransportOperation.h"
#import "JMCComment.h"
#import "JMCIssue.h"
#import "JMCQueueItem.h"
#import "JMCRequestQueue.h"
#import "JMCRecorder.h"

FOUNDATION_EXPORT double JIRAMobileConnectVersionNumber;
FOUNDATION_EXPORT const unsigned char JIRAMobileConnectVersionString[];

