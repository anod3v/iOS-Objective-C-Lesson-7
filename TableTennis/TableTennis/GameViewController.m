//
//  GameViewController.m
//  TableTennis
//
//  Created by Andrey on 20/02/2021.
//

#import "GameViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define HALF_SCREEN_WIDTH SCREEN_WIDTH/2
#define HALF_SCREEN_HEIGHT SCREEN_HEIGHT/2
#define MAX_SCORE 6

@interface GameViewController ()
@property (strong, nonatomic) UIImageView *topRacketImageView;
@property (strong, nonatomic) UIImageView *bottomRacketImageView;
@property (strong, nonatomic) UIView *gridView;
@property (strong, nonatomic) UIView *ballView;
@property (strong, nonatomic) UITouch *topTouch;
@property (strong, nonatomic) UITouch *bottomTouch;
@property (strong, nonatomic) NSTimer * timer;
@property (nonatomic) float dx;
@property (nonatomic) float dy;
@property (nonatomic) float speed;
@property (strong, nonatomic) UILabel *topScoreLabel;
@property (strong, nonatomic) UILabel *bottomScoreLabel;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    [self addSubViews];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    [self newGame];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resignFirstResponder];
}

- (void)setupSubViews {
    [self setupRootView];
    self.gridView = [self createGridView];
    self.topRacketImageView = [self createTopRacketImageView];
    self.bottomRacketImageView = [self createBottomRacketImageView];
    self.ballView = [self createBallView];
    self.topScoreLabel = [self createTopScoreLabel];
    self.bottomScoreLabel = [self createBottomScoreLabel];
}

-(void)addSubViews {
    [self.view addSubview:self.gridView];
    [self.view addSubview:self.topRacketImageView];
    [self.view addSubview:self.bottomRacketImageView];
    [self.view addSubview:self.ballView];
    [self.view addSubview:self.topScoreLabel];
    [self.view addSubview:self.bottomScoreLabel];
}

-(void) setupRootView {
    self.view.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:135.0/255.0 blue:191.0/255.0 alpha:1.0];
}

-(UIView *) createGridView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HALF_SCREEN_HEIGHT - 2, SCREEN_WIDTH, 4)];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    return view;
}

-(UIImageView *) createTopRacketImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 40, 90, 60)];
    imageView.image = [UIImage imageNamed:@"paddleTop"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

-(UIImageView *) createBottomRacketImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT - 90, 90, 60)];
    imageView.image = [UIImage imageNamed:@"paddleBottom"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

-(UIView *) createBallView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - 10, self.view.center.y - 10, 20, 20)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10;
    view.hidden = YES;
    return view;
}

-(UILabel *) createTopScoreLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, HALF_SCREEN_HEIGHT - 70, 50, 50)];
    label.textColor = [UIColor whiteColor];
    label.text = @"0";
    label.font = [UIFont systemFontOfSize:40.0 weight:UIFontWeightLight];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(UILabel *) createBottomScoreLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, HALF_SCREEN_HEIGHT + 70, 50, 50)];
    label.textColor = [UIColor whiteColor];
    label.text = @"0";
    label.font = [UIFont systemFontOfSize:40.0 weight:UIFontWeightLight];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        if (self.bottomTouch == nil && point.y > HALF_SCREEN_HEIGHT) {
            self.bottomTouch = touch;
            self.bottomRacketImageView.center = CGPointMake(point.x, point.y);
        }
        else if (self.topTouch == nil && point.y < HALF_SCREEN_HEIGHT) {
            self.topTouch = touch;
            self.topRacketImageView.center = CGPointMake(point.x, point.y);
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        if (touch == self.topTouch) {
            if (point.y > HALF_SCREEN_HEIGHT) {
                self.topRacketImageView.center = CGPointMake(point.x, HALF_SCREEN_HEIGHT);
                return;
            }
            self.topRacketImageView.center = point;
        }
        else if (touch == self.bottomTouch) {
            if (point.y < HALF_SCREEN_HEIGHT) {
                self.bottomRacketImageView.center = CGPointMake(point.x, HALF_SCREEN_HEIGHT);
                return;
            }
            self.bottomRacketImageView.center = point;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch == self.topTouch) {
            self.topTouch = nil;
        }
        else if (touch == self.bottomTouch) {
            self.bottomTouch = nil;
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}


- (void)displayMessage:(NSString *)message {
    [self stop];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ping Pong" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if ([self gameOver]) {
            [self newGame];
            return;
        }
        [self reset];
        [self start];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)newGame {
    [self reset];
    
    self.topScoreLabel.text = @"0";
    self.bottomScoreLabel.text = @"0";
    
    [self displayMessage:@"Готовы к игре?"];
}

- (int)gameOver {
    if ([self.topScoreLabel.text intValue] >= MAX_SCORE) return 1;
    if ([self.bottomScoreLabel.text intValue] >= MAX_SCORE) return 2;
    return 0;
}

- (void)start {
    self.ballView.center = CGPointMake(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT);
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(animate) userInfo:nil repeats:YES];
    }
    self.ballView.hidden = NO;
}

- (void)reset {
    if ((arc4random() % 2) == 0) {
        self.dx = -1;
    } else {
        self.dx = 1;
    }
    
    if (self.dy != 0) {
        self.dy = -self.dy;
    } else if ((arc4random() % 2) == 0) {
        self.dy = -1;
    } else  {
        self.dy = 1;
    }
    
    self.ballView.center = CGPointMake(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT);
    
    self.speed = 2;
}

- (void)stop {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.ballView.hidden = YES;
}

- (void)animate {
    self.ballView.center = CGPointMake(self.ballView.center.x + self.dx * self.speed, self.ballView.center.y + self.dy * self.speed);
    [self checkCollision:CGRectMake(0, 0, 20, SCREEN_HEIGHT) X:fabs(self.dx) Y:0];
    [self checkCollision:CGRectMake(SCREEN_WIDTH, 0, 20, SCREEN_HEIGHT) X:-fabs(self.dx) Y:0];
    if ([self checkCollision: self.topRacketImageView.frame X:(self.ballView.center.x - self.topRacketImageView.center.x) / 32.0 Y:1]) {
        [self increaseSpeed];
    }
    if ([self checkCollision: self.bottomRacketImageView.frame X:( self.ballView.center.x - self.bottomRacketImageView.center.x) / 32.0 Y:-1]) {
        [self increaseSpeed];
    }
    [self goal];
}

- (void)increaseSpeed {
    self.speed += 0.5;
    if (self.speed > 10) self.speed = 10;
}

- (BOOL)checkCollision: (CGRect)rect X:(float)x Y:(float)y {
    if (CGRectIntersectsRect(self.ballView.frame, rect)) {
        if (x != 0) self.dx = x;
        if (y != 0) self.dy = y;
        return YES;
    }
    return NO;
}

- (BOOL)goal
{
    if (self.ballView.center.y < 0 || self.ballView.center.y >= SCREEN_HEIGHT) {
        int s1 = [self.topScoreLabel.text intValue];
        int s2 = [self.bottomScoreLabel.text intValue];
        
        if (self.ballView.center.y < 0) ++s2; else ++s1;
        self.topScoreLabel.text = [NSString stringWithFormat:@"%u", s1];
        self.bottomScoreLabel.text = [NSString stringWithFormat:@"%u", s2];
        
        int gameOver = [self gameOver];
        if (gameOver) {
            [self displayMessage:[NSString stringWithFormat:@"Игрок %i выиграл", gameOver]];
        } else {
            [self reset];
        }
        
        return YES;
    }
    return NO;
}



@end
