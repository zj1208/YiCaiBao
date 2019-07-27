//
//  WYLayoutManager.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/12/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** WYLMCellDataProtocol*/
@class WYLayoutModel;
@protocol WYLMCellDataProtocol <NSObject>
-(void)setLayoutCellData:(nullable NSDictionary *)cellDict;
@end

/** WYLayoutManager*/
@interface WYLayoutManager : NSObject
- (instancetype)initWithKey:(NSString *)viewController;
@property(nonatomic, readonly) NSInteger sections;
@property(nonatomic, strong, readonly) NSArray<WYLayoutModel*> *list;
- (WYLayoutModel *)getWYLayoutModelWithSection:(NSInteger)section;
- (nullable NSString *)UICollectionViewCellWithSection:(NSInteger)section;//section存在但为填写返回@""，section不存在返回nil
- (nullable NSString *)UICollectionSectionHeaderWithSection:(NSInteger)section;
- (nullable NSString *)UICollectionSectionFooterWithSection:(NSInteger)section;
- (NSString *)identifierWithSection:(NSInteger)section;
- (NSString *)descWithSection:(NSInteger)section;

- (void)registerPlistNibCellsWithCollectionView:(UICollectionView *)collectionView;
@end

/** WYLayoutModel */
@interface WYLayoutModel : NSObject
- (instancetype)initWithDict:(NSDictionary *)dict;
@property(nonatomic) NSInteger section;
@property(nonatomic, copy) NSString *UICollectionViewCell;
@property(nonatomic, copy, nullable) NSString *UICollectionSectionHeader;
@property(nonatomic, copy, nullable) NSString *UICollectionSectionFooter;
@property(nonatomic, copy, nullable) NSString *identifier;
@property(nonatomic, copy, nullable) NSString *desc;
@end
NS_ASSUME_NONNULL_END

