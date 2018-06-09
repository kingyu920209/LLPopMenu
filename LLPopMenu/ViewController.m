//
//  ViewController.m
//  LLPopMenu
//
//  Created by 嘚嘚以嘚嘚 on 2018/6/4.
//  Copyright © 2018年 嘚嘚以嘚嘚. All rights reserved.
//

#import "ViewController.h"
#import "LLPopupMenu.h"
#define TITLES @[@"修改", @"删除", @"扫一扫",@"付款"]
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *t = touches.anyObject;
    CGPoint p = [t locationInView: self.view];
    LLPopupMenu * menu =  [LLPopupMenu showAtPoint:p titles:TITLES icons:nil menuWidth:110 otherSettings:nil];
    menu.didSelectRowBlock = ^(NSIndexPath *indexPath) {
        NSLog(@"%ld",(long)indexPath.row);
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
