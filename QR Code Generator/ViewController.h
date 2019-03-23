//
//  ViewController.h
//  QR Code Generator
//
//  Created by Kyle Howells on 23/03/2019.
//  Copyright © 2019 Kyle Howells. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *correctionLevelSegmentControl;

@end

