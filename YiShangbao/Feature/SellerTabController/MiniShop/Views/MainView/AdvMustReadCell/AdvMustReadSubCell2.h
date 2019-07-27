//
//  AdvMustReadSubCell2.h
//  YiShangbao
//
//  Created by simon on 2018/1/26.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "JLCycSrollCellDataProtocol.h"
#import "MessageModel.h"

@interface AdvMustReadSubCell2 : BaseCollectionViewCell<JLCycSrollCellDataProtocol>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
