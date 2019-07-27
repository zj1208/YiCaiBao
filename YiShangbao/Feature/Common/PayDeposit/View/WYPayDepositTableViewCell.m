//
//  WYPayDepositTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPayDepositTableViewCell.h"
#import "WYPublicModel.h"
NSString * const WYPayDepositTableViewCellID = @"WYPayDepositTableViewCellID";

@interface WYPayDepositTableViewCell()

@property (nonatomic, strong) UILabel *titleNameLabel;
@property (nonatomic, strong) UILabel *depositTipLabel;
@property (nonatomic, strong) UILabel *amountLabel;

@end

@implementation WYPayDepositTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.amountLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.amountLabel];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    self.titleNameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleNameLabel];
    [self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15);
//        make.right.equalTo(self.amountLabel.mas_left).offset(-15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    self.depositTipLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.depositTipLabel];
    [self.depositTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleNameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-100);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    self.titleNameLabel.font = [UIFont systemFontOfSize:15.0];
    self.titleNameLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    self.titleNameLabel.numberOfLines = 0;
    self.depositTipLabel.font = [UIFont systemFontOfSize:14.0];
    self.depositTipLabel.textColor = [UIColor colorWithHex:0x9D9D9D];
    self.depositTipLabel.numberOfLines = 0;
    self.amountLabel.font = [UIFont systemFontOfSize:17.0];
    self.amountLabel.textColor = [UIColor colorWithHex:0xFF5434];
    
    self.titleNameLabel.text = @" ";
    self.depositTipLabel.text = @"首次认证需缴纳保证金，一年后可退";
    self.amountLabel.text = @"¥ ";
    
    [self.amountLabel setContentHuggingPriority:UILayoutPriorityRequired
                                          forAxis:UILayoutConstraintAxisHorizontal];
    [self.amountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                        forAxis:UILayoutConstraintAxisHorizontal];

//    // 虚线
//    UIBezierPath *linePath = [UIBezierPath bezierPath];
//    [linePath moveToPoint:CGPointMake(0, 0)];
//    [linePath addLineToPoint:CGPointMake(SCREEN_WIDTH, 0)];
//    CAShapeLayer *lineLayer = [CAShapeLayer layer];
//    [lineLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:3], nil]];
//    lineLayer.lineWidth = 0.5;
//    lineLayer.strokeColor = [UIColor colorWithHex:0xE1E2E3].CGColor;
//    lineLayer.path = linePath.CGPath;
//    lineLayer.fillColor = nil; // 默认为blackColor
//    [self.dottedLine.layer addSublayer:lineLayer];
    
    return self;
}

- (void)updateData:(WYAuthenticationPayInfoModel *)model{
    self.titleNameLabel.text = model.title;
    self.amountLabel.text = model.promFee;
    self.depositTipLabel.text = model.desc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
