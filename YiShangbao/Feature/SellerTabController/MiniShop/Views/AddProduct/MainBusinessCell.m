//
//  MainBusinessCell.m
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "MainBusinessCell.h"

@implementation MainBusinessCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIImage *selectImage =[UIImage imageNamed:@"ic_xuanzhong"];
    UIImage *noSelectImage = [UIImage imageNamed:@"ic_weixuanzhong"];
    
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)obj;
            [btn setImage:noSelectImage forState:UIControlStateNormal];
            [btn setImage:selectImage forState:UIControlStateSelected];
            [btn setTitleColor:WYUISTYLE.colorMred forState:UIControlStateSelected];
        }
    }];
    self.mainBusinessBtn.selected = YES;
    self.chanceNumLab.text =@"(还可设置0件在商铺首页展示)";
    
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
    self.diskManager = manager;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (IS_IPHONE_6P)
    {
        self.leftMagin.constant =20.f;
    }
}

- (void)setData:(id)data doingType:(DoingType)doingType;
{
    ProductPutawayInitModel *model = (ProductPutawayInitModel *)data;
    AddProductModel *productModel = (AddProductModel *)[self.diskManager getData];

    if (model)
    {
        if (doingType ==DoingType_AddProduct)
        {
            if (model.ifRadioDisplay)
            {
                self.chanceNumLab.text = [NSString stringWithFormat:@"(还可设置%@件在商铺首页展示)",[data timesLeft]];
                self.mainBusinessBtn.selected = productModel.isMain;

            }
            else
            {
                self.mainBusinessBtn.selected = NO;
//                3.26-改为弹框提示
//                self.mainBusinessBtn.userInteractionEnabled = NO;
            }
        }
        else if (doingType ==DoingType_EditProduct)
        {
            //20件还没有用完
            if (model.ifRadioDisplay)
            {
                self.chanceNumLab.text = [NSString stringWithFormat:@"(还可设置%@件在商铺首页展示)",[data timesLeft]];
            }
            else
            {
//                3.26版本-开始可以选择，增加提示
//                if (productModel.getEditOrinalIsMainPro)
//                {
//                    self.mainBusinessBtn.userInteractionEnabled = YES;
//                }
//                else
//                {
//                    self.mainBusinessBtn.userInteractionEnabled = NO;
//                }
            }
            self.mainBusinessBtn.selected = productModel.isMain;
        }
    }
}





- (BOOL)isMainBussiness
{
    return self.mainBusinessBtn.selected;
}
@end
