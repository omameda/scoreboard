//
//  ScoringBoradViewController.h
//  ScoreBoard
//
//  Created by seo hideki on 2013/08/20.
//  Copyright (c) 2013年 seo hideki. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScoringBoradViewController : UIViewController<UIAlertViewDelegate>{
    NSTimer *_timer ;
    NSTimeInterval _startTime;
    
}

@property NSInteger pointOfSet;
@property (retain)NSArray *playerData;
@property (retain)NSDictionary *player1;
@property (retain)NSDictionary *player2;
@property (retain)UIImage *serviceImage;
@property (retain, nonatomic) IBOutlet UILabel *player1Team;
@property (retain, nonatomic) IBOutlet UILabel *player2Team;
@property (retain, nonatomic) IBOutlet UILabel *player1Name;
@property (retain, nonatomic) IBOutlet UILabel *player2Name;
@property (retain, nonatomic) IBOutlet UILabel *player1Point;
@property (retain, nonatomic) IBOutlet UILabel *player2Point;
@property (retain, nonatomic) IBOutlet UILabel *player1Set;
@property (retain, nonatomic) IBOutlet UILabel *player2Set;
@property (retain, nonatomic) IBOutlet UIImageView *player1Service;
@property (retain, nonatomic) IBOutlet UIImageView *player2Service;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIButton *startButton;
- (IBAction)pushButton:(id)sender;
@property (retain, nonatomic) IBOutlet UIStepper *player1Stepper;
- (IBAction)player1ChengeStepper:(id)sender;
@property (retain, nonatomic) IBOutlet UIStepper *player2Stepper;
- (IBAction)player2ChangeStepper:(id)sender;


@end
