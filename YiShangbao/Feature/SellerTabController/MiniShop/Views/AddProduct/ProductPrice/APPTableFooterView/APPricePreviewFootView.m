//
//  APPricePreviewFootView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/3/21.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "APPricePreviewFootView.h"

@implementation APPricePreviewFootView
-(void)setPriceData:(NSArray *)array unit:(NSString *)unit show:(BOOL)show
{
    self.titleLabel.text = @"";
    self.minQuaLabel.text = @"";
    self.firstLabel.text = @"";
    self.secondLabel.text = @"";
    self.thirdLabe.text = @"";
    
    if (show) {
        self.titleLabel.text = @"预览";
        AddProductSetPriceModel *model = array.firstObject;
        
        self.minQuaLabel.text = [NSString stringWithFormat:@"起订量:   %ld%@起批",model.minimumQuantity.integerValue,unit];
        if (array.count == 1) {
            self.firstLabel.text = [NSString stringWithFormat:@"≥%ld%@:  %.2lf元/%@",model.minimumQuantity.integerValue,unit,model.price.doubleValue,unit];
        }
        if (array.count == 2) {
            AddProductSetPriceModel *model_second = array[1];
            
            self.firstLabel.text = [NSString stringWithFormat:@"%ld-%ld%@:   %.2lf元/%@",model.minimumQuantity.integerValue,model_second.minimumQuantity.integerValue-1,unit,model.price.doubleValue,unit];
            self.secondLabel.text = [NSString stringWithFormat:@"≥%ld%@:   %.2lf元/%@",model_second.minimumQuantity.integerValue,unit,model_second.price.doubleValue,unit];
        }
        if (array.count == 3) {
            AddProductSetPriceModel *model_second = array[1];
            AddProductSetPriceModel *model_third = array[2];

            self.firstLabel.text = [NSString stringWithFormat:@"%ld-%ld%@:   %.2lf元/%@",model.minimumQuantity.integerValue,model_second.minimumQuantity.integerValue-1,unit,model.price.doubleValue,unit];
            self.secondLabel.text = [NSString stringWithFormat:@"%ld-%ld%@:   %.2lf元/%@",model_second.minimumQuantity.integerValue,model_third.minimumQuantity.integerValue-1,unit,model_second.price.doubleValue,unit];
            self.thirdLabe.text = [NSString stringWithFormat:@"≥%ld%@:   %.2lf元/%@",model_third.minimumQuantity.integerValue,unit,model_third.price.doubleValue,unit];
        }
    }
}
@end
