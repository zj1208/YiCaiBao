//
//  ProductManageController.h
//  YiShangbao
//
//  Created by simon on 17/2/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductManageController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic,assign)NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numSegmentedControl;

@property (weak, nonatomic) IBOutlet UIView *segmentedContainerView;


@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;

- (IBAction)searchAction:(UIBarButtonItem *)sender;

- (IBAction)pcUploadAction:(UIBarButtonItem *)sender;


@end
