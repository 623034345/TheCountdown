//
//  ViewController.m
//  TheCountdown
//
//  Created by shangce on 16/10/11.
//  Copyright © 2016年 FengYingJie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    dispatch_source_t _timer;

}
@end

@implementation ViewController

-(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *endDate = [dateFormatter dateFromString:[self getyyyymmdd]];
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate] + 72*3600)];
    NSDate *startDate = [NSDate date];
    NSLog(@"开始时间%@",startDate);
    NSTimeInterval timeInterval =[endDate_tomorrow timeIntervalSinceDate:startDate];
    
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.dayLab.text = @"00";
                        self.hhLab.text = @"00";
                        self.mmLab.text = @"00";
                        self.ssLab.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    if (days==0) {
                        self.dayLab.text = @"";
                    }
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days==0) {
                            self.dayLab.text = @"0天";
                        }else{
                            self.dayLab.text = [NSString stringWithFormat:@"%d天",days];
                        }
                        if (hours<10) {
                            self.hhLab.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.hhLab.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            self.mmLab.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.mmLab.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            self.ssLab.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.ssLab.text = [NSString stringWithFormat:@"%d",second];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
