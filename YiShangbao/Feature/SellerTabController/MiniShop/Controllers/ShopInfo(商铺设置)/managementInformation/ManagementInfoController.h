//
//  ManagementInfoController.h
//  YiShangbao
//
//  Created by simon on 17/2/26.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagementInfoController : UITableViewController

@property (nonatomic, copy) NSString *shopId;

//picCell

@property (weak, nonatomic) IBOutlet UIButton *picBtn;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIView *picCellContentView2;

//主营类目
@property (weak, nonatomic) IBOutlet UILabel *categoryLab;
//主营产品
@property (weak, nonatomic) IBOutlet UILabel *shopProLab;
//内销
@property (weak, nonatomic) IBOutlet UIButton *domesticSaleBtn;
//外贸
@property (weak, nonatomic) IBOutlet UIButton *exportSaleBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

//左边距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMagin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMagin2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMagin3;

@property (nonatomic, strong) UIButton *selectSaleBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

- (IBAction)saleTypeAction:(UIButton *)sender;

//品牌
@property (weak, nonatomic) IBOutlet UILabel *brandLab;
//经营年限
@property (weak, nonatomic) IBOutlet UIButton *yearBtn;


//自有工厂
@property (weak, nonatomic) IBOutlet UIButton *ownFactoryBtn;
//批发
@property (weak, nonatomic) IBOutlet UIButton *wholesaleBtn;
//经营模式
@property (nonatomic ,strong)UIButton *selectModelBtn;

//经营模式
- (IBAction)proSoureTypeAction:(UIButton *)sender;


- (IBAction)yearBtnChangeAction:(UIButton *)sender;



- (IBAction)saveBtnAction:(UIButton *)sender;
@end
