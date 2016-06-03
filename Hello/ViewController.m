//
//  ViewController.m
//  Hello
//
//  Created by QSH on 16/5/25.
//  Copyright © 2016年 Zen. All rights reserved.
//

#import "ViewController.h"
#import "GraphicsProcessor.h"
#import "Test.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bwImageView;
@property (weak, nonatomic) IBOutlet UIImageView *font1ImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *image = [UIImage imageNamed:@"vin"];
    
    UIImage *grayImage = [[GraphicsProcessor sharedProcessor] grayImage:image];
    
    UIImage *binaryImage = [[GraphicsProcessor sharedProcessor] binaryImage:grayImage];
    self.bwImageView.image = binaryImage;
    // [[GraphicsProcessor sharedProcessor] logImage:binaryImage];
    // self.font1ImageView.image = [UIImage imageNamed:@"font_0.jpg"];
    
    
    
    NSArray *slices = [[GraphicsProcessor sharedProcessor] divideImage:binaryImage];
    CGFloat space = 30.0;
    for (int i = 0; i < slices.count; i++) {
        CGFloat xOffset = space * i;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0 + xOffset, 100.0, 25.0, 25.0)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.image = slices[i];
        [self.view addSubview:imageView];
        
        NSString *fontPath = [[NSBundle mainBundle] pathForResource:@"font.jpg" ofType:nil];

        NSData *imageData = UIImageJPEGRepresentation(slices[i], 1.0);
        NSString *temporaryDirectory = NSTemporaryDirectory();
        NSString *imagePath = [temporaryDirectory stringByAppendingString:@"slice.jpg"];
        [imageData writeToFile:imagePath atomically:YES];
        
        Test *test = [[Test alloc] init];
        int result = [test similarityOfImage:imagePath andImage:fontPath];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0 + xOffset, 130.0, 25.0, 25.0)];
        label.text = [NSString stringWithFormat:@"%d", result];
        [self.view addSubview:label];
    }
    
    /*
    self.slice1ImageView.backgroundColor = [UIColor lightGrayColor];
    self.slice1ImageView.image = slices[11];
    self.slice2ImageView.backgroundColor = [UIColor lightGrayColor];
    self.slice2ImageView.image = slices[1];
    self.slice3ImageView.backgroundColor = [UIColor lightGrayColor];
    self.slice3ImageView.image = slices[2];
    
    NSData *imageData = UIImageJPEGRepresentation(slices[11], 1.0);
    NSString *temporaryDirectory = NSTemporaryDirectory();
    NSString *imagePath = [temporaryDirectory stringByAppendingString:@"slice.jpg"];
    [imageData writeToFile:imagePath atomically:YES];
    
    self.font1ImageView.image = [UIImage imageNamed:@"font.jpg"];
    
    Test *test = [[Test alloc] init];
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:@"font.jpg" ofType:nil];
    
    int result1 = [test similarityOfImage:imagePath andImage:fontPath];
    self.result1Label.text = [NSString stringWithFormat:@"%d", result1];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
