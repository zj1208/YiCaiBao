//
//  WYLoginHistoryPhonesView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/6/1.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYLoginHistoryPhonesView.h"

@interface WYLoginHistoryPhonesView()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabviewLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabviewLayoutTop;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property(nonatomic, strong) NSArray *arrayTitles;
@end

@implementation WYLoginHistoryPhonesView
-(instancetype)initWithArrayTitles:(NSArray *)titles topLayout:(CGFloat)topLayout heightLayout:(CGFloat)heightLayout
{
    WYLoginHistoryPhonesView* view = [[[NSBundle mainBundle] loadNibNamed:@"WYLoginHistoryPhonesView" owner:self options:nil] firstObject];
    view.arrayTitles = titles;
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

@end
