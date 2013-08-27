//
//  ScoringBoradViewController.m
//  ScoreBoard
//
//  Created by seo hideki on 2013/08/20.
//  Copyright (c) 2013年 seo hideki. All rights reserved.
//

#import "ScoringBoradViewController.h"

@interface ScoringBoradViewController ()

@end

@implementation ScoringBoradViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        //動的にビューを作成する

        //プレイヤーの作成
        self.playerData = [NSArray arrayWithObjects:@"team",@"name",@"set",@"nowPoint",@"service", nil];
        NSArray *player1Default = [NSArray arrayWithObjects:@"team1",@"name1",@"0",@"0",@"NO", nil];
        NSArray *player2Default = [NSArray arrayWithObjects:@"team2",@"name2",@"0",@"0",@"NO", nil];
        self.player1 = [NSDictionary dictionaryWithObjects:player1Default forKeys:self.playerData];
        self.player2 = [NSDictionary dictionaryWithObjects:player2Default forKeys:self.playerData];
        //サーブ権のイメージの作成
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"ishtg02" ofType:@"gif"];
        self.serviceImage = [UIImage imageWithContentsOfFile:path];
        //デフォルト値
        self.pointOfSet = 21;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.]
    //ステッパーを無効にする
    [self reset];
    self.player1Stepper.hidden = YES;
    self.player2Stepper.hidden = YES;
    
}

- (void)reset{
    self.player1Stepper.value = 0;
    self.player1Stepper.minimumValue = 0;
    self.player1Stepper.maximumValue = 30;
    self.player1Stepper.autorepeat = NO;
    self.player1Stepper.stepValue = 1;
    
    self.player2Stepper.value = 0;
    self.player2Stepper.minimumValue = 0;
    self.player2Stepper.maximumValue = 30;
    self.player2Stepper.autorepeat = NO;
    self.player2Stepper.stepValue = 1;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
    [_player1Name release];
    [_player2Name release];
    [_player1Name release];
    [_player2Name release];
    [_player1Set release];
    [_player2Set release];
    [_timeLabel release];
    [_startButton release];
    [_player1Stepper release];
    [_player2Stepper release];
    [_player1Service release];
    [_player2Service release];
    [_player1Point release];
    [_player2Point release];
    [super dealloc];
}
//player2のステッパーのアクション
- (IBAction)player1ChengeStepper:(id)sender {
    NSMutableDictionary *player = [NSMutableDictionary dictionary];
    [player setDictionary:self.player1];
    [player setObject:[NSString stringWithFormat:@"%d",(int)self.player1Stepper.value] forKey:@"nowPoint"];
    [player setObject:@"YES" forKey:@"service"];
    //サーブ権を移す
    NSMutableDictionary *player2 = [NSMutableDictionary dictionary];
    [player2 setDictionary:self.player2];
    [player2 setObject:@"NO" forKey:@"service"];
    self.player2 = player2;

     self.player1 = player;
    [self check];
    [self updateView];
}
//player2のステッパーのアクション
- (IBAction)player2ChangeStepper:(id)sender {
    NSMutableDictionary *player = [NSMutableDictionary dictionary];
    [player setDictionary:self.player2];
    [player setObject:[NSString stringWithFormat:@"%d",(int)self.player2Stepper.value] forKey:@"nowPoint"];
    [player setObject:@"YES" forKey:@"service"];
    //サーブ権を移す
    NSMutableDictionary *player1 = [NSMutableDictionary dictionary];
    [player1 setDictionary:self.player1];
    [player1 setObject:@"NO" forKey:@"service"];
    self.player1 = player1;
    
     self.player2 = player;
    [self check];
    [self updateView];
}
//スタートボタン
- (IBAction)pushButton:(id)sender {
    self.player1Stepper.hidden = NO;
    self.player2Stepper.hidden = NO;
    [self startTimer];
}
//ビューを更新
- (void)updateView{
    //プレイヤー１の設定
    self.player1Team.text = [self.player1 objectForKey:@"team"];
    self.player1Name.text = [self.player1 objectForKey:@"name"];
    self.player1Point.text = [self.player1 objectForKey:@"nowPoint"];
    self.player1Set.text = [self.player1 objectForKey:@"set"];
    if ([[self.player1 objectForKey:@"service"] isEqual:@"YES"]) {
        self.player1Service.image = self.serviceImage;
    }else{
        self.player1Service.image = nil;
    }
    //プレイヤ−２の設定
    self.player2Team.text = [self.player2 objectForKey:@"team"];
    self.player2Name.text = [self.player2 objectForKey:@"name"];
    self.player2Point.text = [self.player2 objectForKey:@"nowPoint"];
    self.player2Set.text = [self.player2 objectForKey:@"set"];
    if ([[self.player2 objectForKey:@"service"] isEqual:@"YES"]) {
        self.player2Service.image = self.serviceImage;
    }else{
        self.player2Service.image = nil;
    }
}

- (void)swap{
    NSDictionary *tmp = self.player1;
    self.player1 = self.player2;
    self.player2 = tmp;
}

- (BOOL)nextSet:(NSDictionary *)player{
    BOOL next = YES;
    //セット数の更新
    NSMutableDictionary *winPlayer = [NSMutableDictionary dictionaryWithDictionary:player];
    NSString *set =  [winPlayer objectForKey:@"set"];
    int setNumber = [set intValue];
    setNumber += 1;

    [winPlayer setObject:[NSString stringWithFormat:@"%d",setNumber] forKey:@"set"];
    NSString *name = [player objectForKey:@"name"];
    if ([name isEqual:[self.player1 objectForKey:@"name"]]) {
        self.player1 = winPlayer;
    }else{
        self.player2 = winPlayer;
    }
    if (setNumber == 2) {
        next = NO;
        return next;
    }
    //点数の初期か
    //player1
    NSMutableDictionary *player1 = [NSMutableDictionary dictionary];
    [player1 setDictionary:self.player1];
    [player1 setObject:@"0" forKey:@"nowPoint"];
    self.player1 = player1;
    
    //player2
    NSMutableDictionary *player2 = [NSMutableDictionary dictionary];
    [player2 setDictionary:self.player2];
    [player2 setObject:@"0" forKey:@"nowPoint"];
    self.player2 = player2;
    
    
    //チェンジコート
    [self swap];
    return next;
    
}

- (void)startTimer{
    _startTime =  [NSDate timeIntervalSinceReferenceDate];
    
    if(!_timer && [_timer isValid]){
        [_timer invalidate];
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(updateTime)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)check{
    NSString *player1StringPoint = [self.player1 objectForKey:@"nowPoint"];
    NSString *player2StringPoint = [self.player2 objectForKey:@"nowPoint"];
    NSInteger player1Point = [player1StringPoint intValue];
    NSInteger player2Point = [player2StringPoint intValue];
    
    //どちらかのプレイヤーが２１点以上かつ２点差以上はなれている
    if ((player1Point >= self.pointOfSet) || (player2Point >= self.pointOfSet)) {
        NSInteger sub = player1Point - player2Point;
        if (sub >= 2) {
            if ([self nextSet:self.player1]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"チェンジエンド"
                                                                message:@"インターバルをとりますか？"
                                                               delegate:self
                                                      cancelButtonTitle:@"NO"
                                                      otherButtonTitles:@"YES", nil];
                [alert show];
                [alert release];
            }else{
                [self gameSet];
            }
        }else if (sub <= -2){
            if([self nextSet:self.player2]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"チェンジエンド"
                                                                message:@"インターバルをとりますか？"
                                                               delegate:self
                                                      cancelButtonTitle:@"NO"
                                                      otherButtonTitles:@"YES", nil];
                [alert show];
                [alert release];
            }else{
                [self gameSet];
            }
            
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.player1Stepper.value = 0;
    self.player2Stepper.value = 0;
    
}

- (void)gameSet{
    NSString *result = [NSString stringWithFormat:@"%@ %@ - %@ %@",[self.player1 objectForKey:@"name"]
                        ,[self.player1 objectForKey:@"set"]
                        ,[self.player2 objectForKey:@"name"]
                        ,[self.player2 objectForKey:@"set"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"試合終了"
                                                    message:result
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"detail", nil];
    [alert show];
    [alert release];
    
    [_timer invalidate];
    _timer = nil;
}

- (void)updateTime{
    NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate] - _startTime;
    int sec = (int)time;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%03d:%02d",sec/60,sec %60];
    
}



@end
