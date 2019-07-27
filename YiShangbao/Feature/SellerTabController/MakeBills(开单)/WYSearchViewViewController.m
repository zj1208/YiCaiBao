//
//  WYSearchViewViewController.m
//  YiShangbao
//
//  Created by light on 2018/2/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYSearchViewViewController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "WYSearchViewCollectionViewCell.h"

@interface WYSearchViewViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *searchWordsArray;

@end

@implementation WYSearchViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    self.searchTextField.text = self.serachWord;
    [self requsetSearchWords];
    [self.searchTextField becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Request
- (void)requsetSearchWords{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getBillSearchWordsSuccess:^(id data) {
        weakSelf.searchWordsArray = [data objectForKey:@"historySearchWords"];
        weakSelf.historyView.hidden = !weakSelf.searchWordsArray.count;
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requsetDeleteSearchWords{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getMakeBillAPI] postBillDeleteSearchWordsSuccess:^(id data) {
        [MBProgressHUD zx_showSuccess:@"删除成功" toView:weakSelf.view];
        [weakSelf requsetSearchWords];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark- ButtonAction
- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)searchButtonAction:(id)sender {
    NSString *str = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length == 0) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchWord:)]) {
        [self.delegate searchWord:str];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (IBAction)deleteButtonAction:(id)sender {
    WS(weakSelf)
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"是否清除搜索记录" message:nil cancelButtonTitle:@"是" cancleHandler:^(UIAlertAction * _Nonnull action) {
        [weakSelf requsetDeleteSearchWords];
    } doButtonTitle:@"取消" doHandler:nil];
}

#pragma mark- 

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.searchWordsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WYSearchViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WYSearchViewCollectionViewCellID" forIndexPath:indexPath];
    cell.titleLabel.text = self.searchWordsArray[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.searchTextField.text = self.searchWordsArray[indexPath.item];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchWord:)]) {
        [self.delegate searchWord:self.searchTextField.text];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}

#pragma mark- Private
- (void)setUI{
    UIImageView *searchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 78/2, 64/2)];
    searchView.image = [UIImage imageNamed:@"ic_search"];
    self.searchTextField.leftView = searchView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.layer.masksToBounds = YES;
    self.searchTextField.layer.cornerRadius = 14.0;
    
    
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 20, 15);
    flowLayout.estimatedItemSize = CGSizeMake(50, 28);
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
//    _collectionView.alwaysBounceVertical = YES;//当数据不足，也能滑动
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;//收缩键盘
    
//    [_collectionView registerNib:[UINib nibWithNibName:@"WYSearchViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WYSearchViewCollectionViewCellID"];
    [_collectionView registerClass:[WYSearchViewCollectionViewCell class] forCellWithReuseIdentifier:@"WYSearchViewCollectionViewCellID"];
    
    self.historyView.hidden = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
