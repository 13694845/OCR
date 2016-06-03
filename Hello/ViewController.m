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

#import "SRAxis.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *grayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bwImageView;

@property (weak, nonatomic) IBOutlet UIImageView *slice1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *slice2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *slice3ImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *image = [UIImage imageNamed:@"vin"];
    self.imageView.image = image;
    
    UIImage *grayImage = [[GraphicsProcessor sharedProcessor] grayImage:image];
    self.grayImageView.image = grayImage;
    
    UIImage *binaryImage = [[GraphicsProcessor sharedProcessor] binaryImage:grayImage];
    self.bwImageView.image = binaryImage;
    // [[GraphicsProcessor sharedProcessor] logImage:binaryImage];
    
    NSArray *slices = [[GraphicsProcessor sharedProcessor] divideImage:binaryImage];
    self.slice1ImageView.backgroundColor = [UIColor lightGrayColor];
    self.slice1ImageView.image = slices[0];
    self.slice2ImageView.backgroundColor = [UIColor lightGrayColor];
    self.slice2ImageView.image = slices[1];
    self.slice3ImageView.backgroundColor = [UIColor lightGrayColor];
    self.slice3ImageView.image = slices[2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
