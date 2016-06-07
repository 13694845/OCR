//
//  ViewController.m
//  Hello
//
//  Created by QSH on 16/5/25.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "ViewController.h"
#import "GraphicsProcessor.h"
#import "CharacterRecognizer.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *binaryImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *image = [UIImage imageNamed:@"vin"];
    
    GraphicsProcessor *graphicsProcessor = [[GraphicsProcessor alloc] init];
    UIImage *grayImage = [graphicsProcessor grayImage:image];
    UIImage *binaryImage = [graphicsProcessor binaryImage:grayImage];
    self.binaryImageView.image = binaryImage;
}

- (void)viewDidAppear:(BOOL)animated {
    GraphicsProcessor *graphicsProcessor = [[GraphicsProcessor alloc] init];
    CharacterRecognizer *characterRecognizer = [[CharacterRecognizer alloc] init];
    NSArray *slices = [graphicsProcessor divideImage:self.binaryImageView.image];
    for (int i = 0; i < slices.count; i++) {
        NSData *imageData = UIImageJPEGRepresentation(slices[i], 1.0);
        NSString *temporaryDirectory = NSTemporaryDirectory();
        NSString *imagePath = [temporaryDirectory stringByAppendingString:@"slice.jpg"];
        [imageData writeToFile:imagePath atomically:YES];
        
        NSString *character = [characterRecognizer characterForImage:imagePath];
        // NSLog(@"character : %@", character);
        printf(" %c ", [character characterAtIndex:0]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
