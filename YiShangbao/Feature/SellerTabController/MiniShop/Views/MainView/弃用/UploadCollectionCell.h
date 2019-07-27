//
//  UploadCollectionCell.h
//  YiShangbao
//
//  Created by simon on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  如果能解决cell边框阴影不被截取问题，就用cell直接添加,不然变复杂了；
//  弃用

#import "BaseCollectionViewCell.h"

@interface UploadCollectionCell : BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView1;
@property (weak, nonatomic) IBOutlet UILabel *titleLab1;
@property (weak, nonatomic) IBOutlet UIButton *badgeOrderBtn1;

@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView1;
@property (weak, nonatomic) IBOutlet UIView *viewContainer1;


@property (weak, nonatomic) IBOutlet UIImageView *iconImgView2;
@property (weak, nonatomic) IBOutlet UILabel *titleLab2;

@property (weak, nonatomic) IBOutlet UIButton *badgeOrderBtn2;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView2;

@property (weak, nonatomic) IBOutlet UIView *viewContainer2;

@end
