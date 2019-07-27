//
//  NoticeServiceTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/8/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "NoticeServiceTableViewCell.h"
#import "SurveyModel.h"

NSString *const NoticeServiceTableViewCellID = @"NoticeServiceTableViewCellID";

@interface NoticeServiceTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;

@end

@implementation NoticeServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateDate:(NSArray *)list{
    if (list.count > 0) {
        MarketAnnouncementModel *model = [list objectAtIndex:0];
        self.titleLabel1.text = model.title;
        self.titleLabel2.text = @"";
    }
    if(list.count > 1){
        MarketAnnouncementModel *model = [list objectAtIndex:1];
        self.titleLabel2.text = model.title;
    }
}

@end
