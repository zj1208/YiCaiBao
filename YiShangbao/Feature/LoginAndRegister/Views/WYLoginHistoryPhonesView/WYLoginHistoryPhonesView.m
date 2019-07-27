//
//  WYLoginHistoryPhonesView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/6/1.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYLoginHistoryPhonesView.h"
#import "WYLoginHistoryPhonesCell.h"
@interface WYLoginHistoryPhonesView()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabviewLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabviewLayoutTop;

@end

static NSString *WYLoginHistoryPhonesCell_resum = @"WYLoginHistoryPhonesCell";
@implementation WYLoginHistoryPhonesView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self buildUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}
-(void)buildUI
{
    self.arrayTitles = [NSMutableArray array];
}
-(void)setTopFollowingWithView:(UIView *)topView
{
    //坐标转换
    CGPoint point = [topView.superview convertPoint:CGPointMake(0, CGRectGetMaxY(topView.frame)) toView:nil];
    self.tabviewLayoutTop.constant = point.y+5.f;
//    NSLog(@"666==%@",NSStringFromCGRect(topView.frame));
//    NSLog(@"666==%@",NSStringFromCGPoint(point));
//    NSLog(@"666==%@",NSStringFromCGRect(self.frame));
    
}
-(void)setArrayTitles:(NSArray *)arrayTitles
{
    _arrayTitles = arrayTitles;
    [self.tableview reloadData];
  
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat H = 44.f*arrayTitles.count;
        CGFloat maxH = CGRectGetHeight(self.frame)-CGRectGetMinY(self.tableview.frame);
        self.tabviewLayoutHeight.constant = H>maxH?maxH:H;
        
//        [self.tableview flashScrollIndicators];
    });
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.tableview.rowHeight = 44.f;
    [self.tableview registerNib:[UINib nibWithNibName:@"WYLoginHistoryPhonesCell" bundle:nil] forCellReuseIdentifier:WYLoginHistoryPhonesCell_resum];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.hvWillRemove) {
        self.hvWillRemove();
    }
    [self removeFromSuperview];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitles.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WYLoginHistoryPhonesCell *cell = [tableView dequeueReusableCellWithIdentifier:WYLoginHistoryPhonesCell_resum forIndexPath:indexPath];
    
    NSDictionary *dict = self.arrayTitles[indexPath.row];
    NSString *phone = [dict objectForKey:@"phone"];
    cell.phoneLabel.text = phone;
    if (indexPath.row == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    }else{
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"F9F9F9" ];
    }
//    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.phoneBlock) {
        NSDictionary *dict = self.arrayTitles[indexPath.row];
        NSString *countryCode = [dict objectForKey:@"countryCode"];
        NSString *phone = [dict objectForKey:@"phone"];
        self.phoneBlock(countryCode, phone);
    }
    if (self.hvWillRemove) {
        self.hvWillRemove();
    }
    [self removeFromSuperview];
}

@end
