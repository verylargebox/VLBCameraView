# Introduction
A UIVIew that shows a live feed of the camera, can be used to take a picture, preview that picture and return an UIImage of that preview.

Even though an UIImagePickerController allows a custom [overlay][2] to ovveride the default camera controls, it gives you no control over its camera bounds. Instead it captures a UIImage in full camera resolution, giving you the option to [edit][3] as a second step.

VLBCameraView creates a *viewport* that displays only a portion of what the camera lense captures. Using that viewport, it creates a cropped UIImage of the full camera resolution. 

# VLBCameraView
The viewport of the VLBCameraView is fixed as a square at 320pt x 320pt. Even though other scales and aspect ratios should be supported, it hasn't been tested in such.

VLBCameraView mimics the 'flash' functionality when taking a picture,  which can be customised via its 'flashView' property.

VLBCameraView gives you the option to save the full resolution images to the camera roll via its 'writeToCameraRoll' property.

Limited supports to customise the underlying AVCaptureConnection is also available.
 
# What is included

* VLBCameraView
The 'VLBCameraView.xcodeproj' builds a static library 'libVLBCameraView.a'

# Cocoapods

-> VLBCameraView (1.0)
   A UIVIew that shows a live feed of the camera, can be used to take a picture, preview the picture and return a UIImage of that preview.
   - Homepage: https://github.com/qnoid/VLBCameraView
   - Source:   https://github.com/qnoid/VLBCameraView.git
   - Versions: 1.0 [master repo]


# Versions
1.0 initial version. Support live feed, take picture, preview, re-take.

# How to use

## Under Interface Builder
* Drag a UIView in the xib and change its type to VLBCameraView.
* Set its frame to (320, 320).
* Set its delegate to a class that implements VLBCameraViewDelegate.
* Call VLBCameraView#takePicture to receive a callback on your delegate with the UIImage

## Under code

	VLBCameraView *cameraView = [[VLBCameraView alloc] initWithFrame:CGRect(320, 320)];
	cameraView.delegate = self; //where self, a class implementing VLBCameraViewDelegate
  	
	[cameraView takePicture];

# Demo

See [VLBCameraViewApp][1].

# Future Work

TBD

# Notes

VLBCameraViewApp also includes the ApplicationTests for this library.

[1]: https://github.com/qnoid/VLBCameraViewApp
[2]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UIImagePickerController_Class/UIImagePickerController/UIImagePickerController.html#//apple_ref/occ/instp/UIImagePickerController/cameraOverlayView
[3]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UIImagePickerController_Class/UIImagePickerController/UIImagePickerController.html#//apple_ref/occ/instp/UIImagePickerController/allowsEditing

# Licence

VLBCameraView published under the MIT license:

Copyright (C) 2013, www.verylargebox.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

