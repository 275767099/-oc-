//
//  GameScene.m
//  YiLinXi
//
//  Created by 易林夕 on 2019/3/6.
//  Copyright © 2019年 易林夕. All rights reserved.
//
/** 屏幕宽高获取**/
#define KScreenH  [[UIScreen mainScreen] bounds].size.height
#define KScreenW  [[UIScreen mainScreen] bounds].size.width

#import "GameScene.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation GameScene {
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
    SKSpriteNode * _heroNode;
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.musicPlayer stop];
    self.musicPlayer=nil;
    self.musicPlayer.delegate = nil;
    [self playM];
}
-(void)playM{
    if (!self.musicPlayer) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bgm" ofType:@"mp3"];
        NSURL *fileUrl = [NSURL URLWithString:filePath];
        self.musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:nil];
        self.musicPlayer.delegate = self;
    }
    
    if (![self.musicPlayer isPlaying]){
        [self.musicPlayer setVolume:0.4];
        [self.musicPlayer prepareToPlay];
        [self.musicPlayer play];
    }
}
-(void)playSoundWithName:(NSString *)name{
    
    //    根据这个数字来区分是哪一个系统声音的
    SystemSoundID soundID = 1;
    //    创建一个系统声音的服务
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([[NSBundle mainBundle]URLForResource:name withExtension:nil]), &soundID);
    //    播放系统声音
    AudioServicesPlaySystemSound(soundID);
//    AudioServicesPlayAlertSound(soundID);
}
- (void)btnClick{
    NSLog(@"下一首");
}
- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    _enemys = [NSMutableArray array];
    _bullets = [NSMutableArray array];
    
    [self playM];
    
    // Get label node from scene and store it for use later
//    _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
//
//    _label.alpha = 0.0;
//    [_label runAction:[SKAction fadeInWithDuration:2.0]];
//
//    CGFloat w = (self.size.width + self.size.height) * 0.05;
//
//    // Create shape node to use during mouse interaction
//    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
//    _spinnyNode.lineWidth = 2.5;
//
//    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
//    [_spinnyNode runAction:[SKAction sequence:@[
//                                                [SKAction waitForDuration:0.5],
//                                                [SKAction fadeOutWithDuration:0.5],
//                                                [SKAction removeFromParent],
//                                                ]]];
    
    _heroNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"01"] size:CGSizeMake(50, 50)];
    _heroNode.position = CGPointMake(self.size.width/2, _heroNode.size.height/2);
    [self addChild:_heroNode];
    
    SKAction *actionAddEnemy = [SKAction runBlock:^{
        [self addEnemy];
    }];
    SKAction *actionWaitNextEnemy = [SKAction waitForDuration:0.3];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[actionAddEnemy,actionWaitNextEnemy]]]];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(KScreenW-70, 10, 60, 30);
    [btn setTitle:@"下一首" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}


- (void)touchDownAtPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor greenColor];
    [self addChild:n];
}

- (void)touchMovedToPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor blueColor];
    [self addChild:n];
}

- (void)touchUpAtPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor redColor];
    [self addChild:n];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
    [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    
    for (UITouch *t in touches) {
        _heroNode.position = [t locationInNode:self];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {
        _heroNode.position = [t locationInNode:self];
        
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        _heroNode.position = [t locationInNode:self];
        
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        _heroNode.position = [t locationInNode:self];
        
    }
}
- (void)addEnemy {
    SKSpriteNode *enemy = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"02"] size:CGSizeMake(40, 40)];
    //设定敌机的出现位置横坐标随机randomX
    CGSize winSize = self.size;
    int minX = enemy.size.width / 2;
    int maxX = winSize.width - enemy.size.width/2;
    int rangeX = maxX - minX;
    int randomX = (arc4random() % rangeX) + minX;
    
    //设置敌机初始位置并添加敌机进场景
    enemy.position = CGPointMake(randomX,winSize.height + enemy.size.height/2);
    [self addChild:enemy];
    
    //设定敌机飞向英雄的时间，随机来控制不同的敌机飞行速度
    int minDuration = 2.0;
    int maxDuration = 6.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    //执行敌机从起始点飞向英雄的动作
    SKAction *actionMove = [SKAction moveTo:CGPointMake(randomX,enemy.size.height/2)
                                   duration:actualDuration];
    SKAction *actionMoveDone = [SKAction runBlock:^{
        [enemy removeFromParent];
        [self.enemys removeObject:enemy];
        
    }];
    [enemy runAction:[SKAction sequence:@[actionMove,actionMoveDone]]];
    
    [self.enemys addObject:enemy];
}
- (void)shot
{
    SKSpriteNode* bulletNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"03"] size:CGSizeMake(8, 8)];;
    bulletNode.position = CGPointMake(_heroNode.position.x, _heroNode.position.y + _heroNode.size.height/2);
    [self addChild:bulletNode];
    SKAction *actionMove = [SKAction moveTo:CGPointMake(bulletNode.position.x,self.size.height + bulletNode.size.height)
                                   duration:1];
    SKAction *actionMoveDone = [SKAction runBlock:^{
        [bulletNode removeFromParent];
    }];
    [bulletNode runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    [self.bullets addObject:bulletNode];
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    static int countNum = 0;
    static int tempNum=0;
    if (tempNum>20)
    {
        [self shot];
        tempNum=0;
    }
    tempNum++;
   
    
    NSMutableArray *bulletsToDelete = [[NSMutableArray alloc] init];
    for (SKSpriteNode *bullet in self.bullets) {
        
        NSMutableArray *enemysToDelete = [[NSMutableArray alloc] init];
        for (SKSpriteNode *enemy in self.enemys) {
            
            if (CGRectIntersectsRect(bullet.frame, enemy.frame)) {
                [enemysToDelete addObject:enemy];
            }
        }
        
        for (SKSpriteNode *enemy in enemysToDelete) {
            [self.enemys removeObject:enemy];
            [enemy removeFromParent];
            [self playSoundWithName:@"b001.aiff"];
            //** 击败特效
            SKSpriteNode * ddd = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"04"] size:CGSizeMake(35, 35)];
            ddd.position = CGPointMake(enemy.position.x,enemy.position.y);
            [self addChild:ddd];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ddd removeFromParent];
            });
             countNum++;
            if (countNum == 30) {
                [self playSoundWithName:@"s001.aiff"];
                SKSpriteNode * ddd = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"001"] size:CGSizeMake(80, 80)];
                ddd.position = CGPointMake(self.size.width/2, self.size.height/2);
                [self addChild:ddd];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ddd removeFromParent];
                });
            }
            if (countNum == 60) {
                [self playSoundWithName:@"s001.aiff"];
                SKSpriteNode * ddd = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"002"] size:CGSizeMake(80, 80)];
                ddd.position = CGPointMake(self.size.width/2, self.size.height/2);
                [self addChild:ddd];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ddd removeFromParent];
                });
            }
            if (countNum == 90) {
                [self playSoundWithName:@"s001.aiff"];
                SKSpriteNode * ddd = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"003"] size:CGSizeMake(80, 80)];
                ddd.position = CGPointMake(self.size.width/2, self.size.height/2);
                [self addChild:ddd];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ddd removeFromParent];
                });
            }
            if (countNum == 120) {
                [self playSoundWithName:@"s001.aiff"];
                SKSpriteNode * ddd = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"004"] size:CGSizeMake(80, 80)];
                ddd.position = CGPointMake(self.size.width/2, self.size.height/2);
                [self addChild:ddd];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ddd removeFromParent];
                });
            }
            if (countNum == 150) {
                [self playSoundWithName:@"s001.aiff"];
                SKSpriteNode * ddd = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"005"] size:CGSizeMake(80, 80)];
                ddd.position = CGPointMake(self.size.width/2, self.size.height/2);
                [self addChild:ddd];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ddd removeFromParent];
                });
            }
            if (countNum == 30*6) {
                [self playSoundWithName:@"s001.aiff"];
                SKSpriteNode * ddd = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"006"] size:CGSizeMake(80, 80)];
                ddd.position = CGPointMake(self.size.width/2, self.size.height/2);
                [self addChild:ddd];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ddd removeFromParent];
                });
            }
            if (countNum == 30*7) {
                [self playSoundWithName:@"s001.aiff"];
                SKSpriteNode * ddd = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"007"] size:CGSizeMake(80, 80)];
                ddd.position = CGPointMake(self.size.width/2, self.size.height/2);
                [self addChild:ddd];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ddd removeFromParent];
                });
            }
            if (countNum == 30*8) {
                [self playSoundWithName:@"s001.aiff"];
                SKSpriteNode * ddd = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"008"] size:CGSizeMake(80, 80)];
                ddd.position = CGPointMake(self.size.width/2, self.size.height/2);
                [self addChild:ddd];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ddd removeFromParent];
                });
            }
            if (countNum == 30*9) {
                [self playSoundWithName:@"s002.aiff"];
                SKSpriteNode * ddd = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"shengli"] size:CGSizeMake(80, 80)];
                ddd.position = CGPointMake(self.size.width/2, self.size.height/2);
                [self addChild:ddd];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     countNum = 0;
                     [ddd removeFromParent];
                });
            }
        }
        
        if (enemysToDelete.count > 0) {
            [bulletsToDelete addObject:bullet];
        }
    }
    
    for (SKSpriteNode *projectile in bulletsToDelete) {
        [self.bullets removeObject:projectile];
        [projectile removeFromParent];
    }
    
}




@end
