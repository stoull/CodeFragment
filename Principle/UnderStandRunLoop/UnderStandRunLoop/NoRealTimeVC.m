//
//  NoRealTimeVC.m
//  UnderStandRunLoop
//
//  Created by Stoull Hut on 16/03/2018.
//  Copyright © 2018 CCApril. All rights reserved.
//

#import "NoRealTimeVC.h"

@interface NoRealTimeVC ()
@property (nonatomic, weak) NSTimer *timer1;
@property (nonatomic, strong) NSThread *thread1;
@end

@implementation NoRealTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self creatAThread];
}

- (void)creatAThread{
    // 由于下面的方法无法拿到NSThread的引用，也就无法控制线程的状态
    //[NSThread detachNewThreadSelector:@selector(performTask) toTarget:self withObject:nil];
    
    self.thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(performTask) object:nil];
    [self.thread1 start];
}

- (void)performTask{
    // 使用下面的方式创建定时器虽然会自动加入到当前线程的RunLoop中，但是除了主线程外其他线程的RunLoop默认是不会运行的，必须手动调用
    __weak typeof(self) weakSelf = self;
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:true block:^(NSTimer * _Nonnull timer) {
        if ([NSThread currentThread].isCancelled) {
            [weakSelf.timer1 invalidate];
        }
        NSLog(@"self.timer1 ....");
    }];
    
    NSLog(@"Runloop before prefromSelector");
    
    // 区分直接调用和「performSelector:withObject:afterDelay:」区别,下面的直接调用无论是否运行RunLoop一样可以执行，但是后者则不行。
    //[self caculate];
    
    //performSelector:withObject:afterDelay:执行的本质还是通过创建一个NSTimer然后加入到当前线程RunLoop（通而过前后两次打印RunLoop信息可以看到此方法执行之后RunLoop的timer会增加1个
    [self performSelector:@selector(caculate) withObject:nil afterDelay:2.0];
    
    // 取消当前RunLoop中注册的selector（注意：只是当前RunLoop，所以也只能在当前RunLoop中取消）
    // [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(caculate) object:nil];
    
    NSLog(@"Runloop after performSelector");
    
    // 非主线程RunLoop必须手动调用
    [[NSRunLoop currentRunLoop] run];
    
    NSLog(@"注意：如果RunLoop不退出（运行中），这里的代码并不会执行，RunLoop本身就是一个循环.");
    
}

// NSTimer 非实时需要等到这个执完毕,才执行对应的Block
- (void)caculate{
    NSLog(@"Begin run caculate");
    for (int i = 0; i < 9999; i++){
        //        NSLog(@"i : %@",[NSThread currentThread].description);
        if ([NSThread currentThread].isCancelled) {
            return;
        }
    }
    NSLog(@"Finished run caculate");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [self.timer1 invalidate];
    NSLog(@"ViewController dealloc");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.thread1 cancel];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
