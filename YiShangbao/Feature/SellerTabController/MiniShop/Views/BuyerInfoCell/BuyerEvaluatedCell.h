//
//  BuyerEvaluatedCell.h
//  YiShangbao
//
//  Created by simon on 2018/3/20.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

extern NSString *const BuyerEvaluatedCellID;

@interface BuyerEvaluatedCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;

@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@property (weak, nonatomic) IBOutlet UILabel *evaluateTypeNameLab;

@property (weak, nonatomic) IBOutlet UILabel *evaluateContentLab;
@end
