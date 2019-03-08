//
//  GameViewController.m
//  YiLinXi
//
//  Created by 易林夕 on 2019/3/6.
//  Copyright © 2019年 易林夕. All rights reserved.
//
/** 屏幕宽高获取**/
#define KScreenH  [[UIScreen mainScreen] bounds].size.height
#define KScreenW  [[UIScreen mainScreen] bounds].size.width

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load the SKScene from 'GameScene.sks'
//    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    GameScene * scene = [[GameScene alloc] initWithSize:CGSizeMake(KScreenW, KScreenH)];
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    
    // Present the scene
    [skView presentScene:scene];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
