//
//  VLBCameraTest.m
//  VLBCameraView
//
//  Created by Markos Charatzas on 29/06/2013.
//  Copyright (c) 2013 www.verylargebox.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Kiwi/Kiwi.h>
#import <OCMock/OCMock.h>
#import <AVFoundation/AVFoundation.h>
#import "VLBCameraView.h"

//testing
typedef void(^VLBCaptureStillImageBlock)(CMSampleBufferRef imageDataSampleBuffer, NSError *error);

@interface VLBCameraView (Test)
@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic, strong) AVCaptureConnection *stillImageConnection;
@property(nonatomic, weak) UIImageView* preview;

-(VLBCaptureStillImageBlock) didFinishTakingPicture:(AVCaptureSession*) session preview:(UIImageView*)preview videoPreviewLayer:(AVCaptureVideoPreviewLayer*) videoPreviewLayer;
@end

@interface VLBCameraViewTestDelegate : NSObject <VLBCameraViewDelegate>
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSDictionary *info;
@property(nonatomic, strong) NSDictionary *meta;
@end

@implementation VLBCameraViewTestDelegate

-(void)cameraView:(VLBCameraView *)cameraView didFinishTakingPicture:(UIImage *)image withInfo:(NSDictionary *)info meta:(NSDictionary *)meta{
    self.image = image;
		self.info = info;
		self.meta = meta;
}

-(void)cameraView:(VLBCameraView *)cameraView didErrorOnTakePicture:(NSError *)error{
}

@end


@interface VLBCameraViewTest : SenTestCase

@end

@implementation VLBCameraViewTest

@end

SPEC_BEGIN(VLBCameraSpec)

context(@"assert video preview will fill the camera view; given a new VLBCameraView instance, AVCaptureVideoPreviewLayer", ^{
    it(@"should have videogravity of AVLayerVideoGravityResizeAspectFill", ^{
        VLBCameraView *cameraView = [[VLBCameraView alloc] initWithFrame:CGRectZero];
        
        [[cameraView.videoPreviewLayer.videoGravity should] equal:AVLayerVideoGravityResizeAspectFill];
    });
});

context(@"assert 'white flash' will be shown when photo is taken; given a new VLBCameraView instance", ^{
    it(@"should have a flashview with superlayer of AVCaptureVideoPreviewLayer", ^{
        VLBCameraView *cameraView = [[VLBCameraView alloc] initWithFrame:CGRectZero];
        
        [[cameraView.flashView.layer.superlayer should] equal:cameraView.videoPreviewLayer];
        [[cameraView.flashView.backgroundColor should] equal:[UIColor whiteColor]];
        [[theValue(cameraView.preview.alpha) should] equal:theValue(0.0f)];        
    });
});

context(@"assert delegate gets callbacks; given a new VLBCameraView instance ", ^{
    it(@"should callback its delegate with AVCaptureVideoPreviewLayer when callbackOnDidCreateCaptureConnection is YES", ^{
        
        id mockedDelegate = [OCMockObject mockForProtocol:@protocol(VLBCameraViewDelegate)];
        AVCaptureConnection *mockedCaptureConnection = [OCMockObject niceMockForClass:[AVCaptureConnection class]];
        
        VLBCameraView *cameraView = [[VLBCameraView alloc] initWithCoder:nil];
        cameraView.delegate = mockedDelegate;
        cameraView.callbackOnDidCreateCaptureConnection = YES;
        
        [[mockedDelegate expect] cameraView:cameraView didCreateCaptureConnection:mockedCaptureConnection];
        
        [cameraView cameraView:cameraView didCreateCaptureConnection:mockedCaptureConnection];

        [mockedDelegate verify];
    });
});

context(@"assert camera did finish taking picture of 8mpx image", ^{
    it(@"should have an image of specified size correctly orientated with meta", ^{
		VLBCameraViewTestDelegate *delegate = [[VLBCameraViewTestDelegate alloc] init];
        VLBCameraView *cameraView = [[VLBCameraView alloc] initWithFrame:CGRectZero];
		cameraView.delegate = delegate;
        id mockedCaptureVideoPreviewLayer = [OCMockObject niceMockForClass:[AVCaptureVideoPreviewLayer class]];
        NSData *imageData = [NSData dataWithContentsOfURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"8mpximage" withExtension:@"png"]];
        UIImage *an8mpxImageAsTakenByCamera = [UIImage imageWithCGImage:[UIImage imageWithData:imageData].CGImage
                                                                  scale:1.0f
                                                            orientation:UIImageOrientationRight];
		CGPoint point = CGPointMake(0.124413,1);
		[[[mockedCaptureVideoPreviewLayer stub] andReturnValue:OCMOCK_VALUE(point)] captureDevicePointOfInterestForPoint:CGPointZero];
		cameraView.videoPreviewLayer = mockedCaptureVideoPreviewLayer;

        [cameraView cameraView:cameraView didFinishTakingPicture:an8mpxImageAsTakenByCamera withInfo:nil meta:nil];

        [[theValue(delegate.image.size) should] equal:theValue(CGSizeMake(2448, 2449))];        
        [[theValue(delegate.image.imageOrientation) should] equal:theValue(UIImageOrientationRight)];        
        [[[delegate.meta objectForKey:VLBCameraViewMetaOriginalImage] should] equal:an8mpxImageAsTakenByCamera];
        BOOL haveEqualCrops = CGRectEqualToRect([[delegate.meta objectForKey:VLBCameraViewMetaCrop]CGRectValue], CGRectMake(406.08398f, 0.0f, 2448.0f, 2857.916f));
        [[theValue(haveEqualCrops) should] equal:theValue(YES)];
    });
});

SPEC_END
