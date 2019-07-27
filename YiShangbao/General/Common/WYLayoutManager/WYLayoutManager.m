//
//  WYLayoutManager.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/12/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//

#import "WYLayoutManager.h"

@interface WYLayoutManager ()
@end

@implementation WYLayoutManager
-(instancetype)initWithKey:(NSString *)viewController
{
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"WYLayoutManager" ofType:@"plist"];
        NSMutableDictionary *dictAllData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSDictionary *dict = [dictAllData objectForKey:viewController];
        NSLog(@"%@",dict);
        
        [self initList:dict];
    }
    return self;
}
#pragma mark 初始化布局数据
-(void)initList:(NSDictionary *)dict
{
    NSInteger sectionsK = [[dict objectForKey:@"sections"] integerValue];
    _sections = sectionsK>0?sectionsK:0;
    NSMutableArray *arrayM = [NSMutableArray array];
    NSArray *arr = [dict objectForKey:@"list"]; //初始化模型数组
    for (int i=0; i<arr.count; ++i) {
        NSDictionary *cellDict= arr[i];
        WYLayoutModel *model = [[WYLayoutModel alloc] initWithDict:cellDict];
        [arrayM addObject:model];
    }
    for (int i=0; i<arrayM.count; ++i) { //初始化时数组按section排序,优化查找时效率
        for (int j=0; j<arrayM.count-1; ++j) {
            WYLayoutModel *model_j = arrayM[j];
            WYLayoutModel *model_jj = arrayM[j+1];
            if (model_j.section>model_jj.section) {
                [arrayM exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    _list = [NSArray arrayWithArray:arrayM];
}
#pragma mark 根据plist配置注册,只支持Xib
-(void)registerPlistNibCellsWithCollectionView:(UICollectionView *)collectionView
{
    for (int i=0; i<self.sections; ++i) {
        WYLayoutModel *model = [self getWYLayoutModelWithSection:i];
        if (model) {
            if (model.UICollectionViewCell&&![model.UICollectionViewCell isEqualToString:@""]) {
                [collectionView registerNib:[UINib nibWithNibName:model.UICollectionViewCell bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:model.UICollectionViewCell];
            }else{
                [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
            }
            if (model.UICollectionSectionHeader&&![model.UICollectionSectionHeader isEqualToString:@""]) {
                [collectionView registerNib:[UINib nibWithNibName:model.UICollectionSectionHeader bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:model.UICollectionSectionHeader];
            }else{
                [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionSectionHeader"];
            }
            if (model.UICollectionSectionFooter&&![model.UICollectionSectionFooter isEqualToString:@""]) {
                [collectionView registerNib:[UINib nibWithNibName:model.UICollectionSectionFooter bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:model.UICollectionSectionFooter];
            }else{
                [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionSectionFooter"];
            }
        }else{
            [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
            [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionSectionHeader"];
            [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionSectionFooter"];
        }
    }
}
#pragma mark 查找数据
-(WYLayoutModel *)getWYLayoutModelWithSection:(NSInteger)section
{
    for (int i=0; i<self.list.count; ++i) {
        WYLayoutModel *model = self.list[i];
        if (model.section ==section) {
            return model;
        }
    }
    return nil;
}
- (nullable NSString *)UICollectionViewCellWithSection:(NSInteger)section
{
    WYLayoutModel *model = [self getWYLayoutModelWithSection:section];
    return model.UICollectionViewCell;
}
- (nullable NSString *)UICollectionSectionHeaderWithSection:(NSInteger)section
{
    WYLayoutModel *model = [self getWYLayoutModelWithSection:section];
    return model.UICollectionSectionHeader;
}
- (nullable NSString *)UICollectionSectionFooterWithSection:(NSInteger)section
{
    WYLayoutModel *model = [self getWYLayoutModelWithSection:section];
    return model.UICollectionSectionFooter;
}
- (NSString *)identifierWithSection:(NSInteger)section
{
    WYLayoutModel *model = [self getWYLayoutModelWithSection:section];
    return model.identifier;
}
- (NSString *)descWithSection:(NSInteger)section
{
    WYLayoutModel *model = [self getWYLayoutModelWithSection:section];
    return model.desc;
}
@end

/**--------------------WYLayoutModel--------------------------------*/
#pragma mark - WYLayoutModel
@implementation WYLayoutModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.section = [[dict objectForKey:@"section"] integerValue];
        
        NSString *UICollectionViewCellS = [self deleteWhitespace:[dict objectForKey:@"UICollectionViewCell"]];
        self.UICollectionViewCell = UICollectionViewCellS;
        NSString *UICollectionSectionHeaderS = [self deleteWhitespace:[dict objectForKey:@"UICollectionSectionHeader"]];
        self.UICollectionSectionHeader = UICollectionSectionHeaderS;
        NSString *UICollectionSectionFooterS = [self deleteWhitespace:[dict objectForKey:@"UICollectionSectionFooter"]];
        self.UICollectionSectionFooter = UICollectionSectionFooterS;
        
        self.identifier = [dict objectForKey:@"identifier"];
        self.desc = [dict objectForKey:@"desc"];
    }
    return self;
}
-(NSString *)deleteWhitespace:(NSString *)str;
{
    NSCharacterSet *whitespaceLine = [NSCharacterSet  whitespaceAndNewlineCharacterSet];//过滤两端空格和换行符
    NSRange spaceRange = [str rangeOfCharacterFromSet:whitespaceLine];
    if (spaceRange.location != NSNotFound)
    {
        str = [str stringByTrimmingCharactersInSet:whitespaceLine];
    }
    return str;
}
@end

