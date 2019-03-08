//
//  GameScene.h
//  YiLinXi
//
//  Created by 易林夕 on 2019/3/6.
//  Copyright © 2019年 易林夕. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GameScene : SKScene <AVAudioPlayerDelegate>

@property(nonatomic,retain)NSMutableArray * enemys;
@property(nonatomic,retain)NSMutableArray * bullets;
@property(nonatomic,retain)AVAudioPlayer * musicPlayer;
@end
