//
//  EditViewController.m
//  scrawl
//
//  Created by 王定方 on 15/7/9.
//  Copyright (c) 2015年 王定方. All rights reserved.
//

#import "EditViewController.h"
#import "ScrawlControlView.h"

@interface EditViewController ()

@property (nonatomic, strong) IBOutlet UIView *imagesContainerView;

@property (nonatomic, strong) IBOutlet UIView *editContainerView;

@property (nonatomic, strong) ScrawlControlView *editView;

///待添加image的Position
@property (nonatomic, assign) CGPoint position;
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _editView = [[ScrawlControlView alloc] initWithFrame:_editContainerView.bounds];
    _editView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
    [_editContainerView addSubview:_editView];
    
    //起始位置
    _position = CGPointZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changePanWidth:(id)sender {

    UIButton *btn = (UIButton *)sender;
    NSLog(@"btn.text = %@", btn.titleLabel.text);
}


- (IBAction)saveImageAction:(id)sender {

    UIImage *image = _editView.image;
    [_editView clearImage];
    
    NSLog(@"image = %@", image);
    
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGRect frame = imageView.frame;
        imageView.backgroundColor = [UIColor clearColor];
        CGFloat xPos = _position.x;
        CGFloat yPos = _position.y;
        if (xPos + frame.size.width > _editView.bounds.size.width) {
            xPos = 0;
            yPos = _position.y + frame.size.height;
            _position = CGPointMake(xPos, yPos);
        }
        
        frame.origin = _position;
        imageView.frame = frame;
        [_imagesContainerView addSubview:imageView];
        
        _position.x += frame.size.width;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
