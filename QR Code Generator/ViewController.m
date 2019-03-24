//
//  ViewController.m
//  QR Code Generator
//
//  Created by Kyle Howells on 23/03/2019.
//  Copyright © 2019 Kyle Howells. All rights reserved.
//

#import "ViewController.h"
@import CoreImage;

@interface ViewController () <UITextViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.correctionLevelSegmentControl addTarget:self action:@selector(generateQRCode) forControlEvents:UIControlEventValueChanged];
	
	self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	
	self.textView.text = @"Hello World!";
	self.textView.delegate = self;
	
	[self generateQRCode];
	
	[self registerForKeyboardNotifications];
}

-(void)textViewDidChange:(UITextView *)textView{
	[self generateQRCode];
}

-(void)generateQRCode{
	NSString *contents = self.textView.text;
	
	// Generate the image
	CIImage *qrCode = [self createQRForString:contents];
	
	// Rescale to fit the view
	CGFloat viewWidth = self.imageView.bounds.size.width;
	CGFloat scale = viewWidth/qrCode.extent.size.width;
	CIImage *scaledImage = [qrCode imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
	
	// Display
	self.imageView.image = [UIImage imageWithCIImage:scaledImage];
}

-(CIImage*)createQRForString:(NSString *)qrString{
	// Convert the string to a NSISOLatin1StringEncoding encoded NSData object
	NSData *stringData = [qrString dataUsingEncoding:NSISOLatin1StringEncoding];
	
	// Create QR Code Filter
	CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
	
	// Set the QR Code contents
	[qrFilter setValue:stringData forKey:@"inputMessage"];
	
	NSString *correctionLevel = @"M";
	switch (self.correctionLevelSegmentControl.selectedSegmentIndex) {
		case 0:
			correctionLevel = @"L";
			break;
		case 1:
			correctionLevel = @"M";
			break;
		case 2:
			correctionLevel = @"Q";
			break;
		case 3:
			correctionLevel = @"H";
			break;
		default:
			break;
	}
	[qrFilter setValue:correctionLevel forKey:@"inputCorrectionLevel"];
	
	return qrFilter.outputImage;
}

#pragma mark - Keyboard

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
	NSDictionary* info = [aNotification userInfo];
	CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
	self.scrollView.contentInset = contentInsets;
	self.scrollView.scrollIndicatorInsets = contentInsets;
	
	// If active text field is hidden by keyboard, scroll it so it's visible
	// Your application might not need or want this behavior.
	CGRect aRect = self.view.frame;
	aRect.size.height -= kbSize.height;
	if (!CGRectContainsPoint(aRect, self.textView.frame.origin) ) {
		CGPoint scrollPoint = CGPointMake(0.0, self.textView.frame.origin.y-kbSize.height);
		[self.scrollView setContentOffset:scrollPoint animated:YES];
	}
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
	UIEdgeInsets contentInsets = UIEdgeInsetsZero;
	self.scrollView.contentInset = contentInsets;
	self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
