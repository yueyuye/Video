//
//  PKScreenViewController.m
//  视频提炼
//
//  Created by 启微时代 on 2017/3/27.
//  Copyright © 2017年 启微时代. All rights reserved.
//

#import "PKScreenViewController.h"
#import "PKFullScreenPlayerView.h"
#import <AVFoundation/AVFoundation.h>
@interface PKScreenViewController ()
@property (nonatomic, strong) PKFullScreenPlayerView *playerView;

@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) UIImage *image;
@end

@implementation PKScreenViewController

- (instancetype)initWithVideoPath:(NSString *)videoPath previewImage:(UIImage *)previewImage {
    NSParameterAssert(videoPath != nil);
    //    NSParameterAssert(previewImage != nil);
    
    self = [super init];
    if (self) {
        _videoPath = videoPath;
        _image = previewImage;
    }
    return self;
}

- (void)dealloc {
    [_playerView pause];
}



#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //静音模式也有声音
    if (![[AVAudioSession sharedInstance].category isEqualToString:AVAudioSessionCategoryPlayback]) {
        [[AVAudioSession sharedInstance] setCategory :AVAudioSessionCategoryPlayback error:nil];
    }
     
    self.view.backgroundColor = [UIColor blackColor];
    
    CGSize viewSize = self.view.bounds.size;
    CGSize imageSize = self.image.size;
    
    self.playerView = [[PKFullScreenPlayerView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width*0.5, viewSize.width* (imageSize.height/imageSize.width*0.5) ) videoPath:self.videoPath previewImage:self.image];
    self.playerView.center = self.view.center;
    
    [self.view addSubview:self.playerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Tap GestureRecognizer

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap {
    [self.playerView pause];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.25];
    [animation setType: kCATransitionFade];
    
    [animation setSubtype: kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self dismissViewControllerAnimated:NO completion:NULL];
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
