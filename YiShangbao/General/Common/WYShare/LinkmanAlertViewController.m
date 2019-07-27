//
//  LinkmanAlertViewController.m
//  YiShangbao
//
//  Created by light on 2018/4/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "LinkmanAlertViewController.h"
#import "LinkmanHeadCollectionViewCell.h"
#import "ZXPlaceholdTextView.h"
#import "WYCollectionView.h"

#import "IQKeyboardManager.h"
#import "WYPublicModel.h"

@interface LinkmanAlertViewController () <UICollectionViewDataSource,UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet WYCollectionView *headCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet ZXPlaceholdTextView *remarkTextView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewCenterY;

//分享内容
@property (nonatomic, strong) NSArray *userList;
@property (nonatomic) id imageStr;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;

@end

@implementation LinkmanAlertViewController

#pragma mark ------LifeCircle------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)shareToUsers:(NSArray *)users image:(id)imageStr Title:(NSString *)title Content:(NSString *)content withUrl:(NSString *)url{
    self.userList = users;
    self.imageStr = imageStr;
    self.shareTitle = title;
    self.content = content;
    self.url = url;
    
    [self.headCollectionView reloadData];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [[IQKeyboardManager sharedManager]setEnable:NO];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showIn:(UIViewController *)viewController{
    [[IQKeyboardManager sharedManager]setEnable:NO];
    [viewController addChildViewController:self];
    
    if (viewController.navigationController){
        [viewController.navigationController addChildViewController:self];
        [viewController.navigationController.view addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewController.navigationController.view);
            make.left.equalTo(viewController.navigationController.view);
            make.right.equalTo(viewController.navigationController.view);
            make.bottom.equalTo(viewController.navigationController.view);
        }];
    }
}

#pragma mark ------Request------
- (void)sendRequest{
    WS(weakSelf);
    NSString *userIds = [NSString string];
    for (WYShareLinkmanModel *model in self.userList) {
        if (userIds.length > 0) {
            userIds = [userIds stringByAppendingString:@","];
        }
        userIds = [userIds stringByAppendingString:model.bizUid];
    }
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [[[AppAPIHelper shareInstance] getNimAccountAPI] postNIMSendBatchMsgToIds:userIds picUrl:weakSelf.imageStr recommendation:weakSelf.content title:weakSelf.shareTitle linkUrl:weakSelf.url addedText:weakSelf.remarkTextView.text success:^(id data) {
        [weakSelf sendSuccess];
        [MBProgressHUD zx_showSuccess:@"发送成功" toView:nil];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}

#pragma mark ------ButtonAction------

- (IBAction)cancelButtonAction:(id)sender {
    [self close];
}

- (IBAction)sendButtonAction:(id)sender {
    [self sendRequest];
}

- (void)sendSuccess{
    if (self.sendSuccessBlock) {
        self.sendSuccessBlock();
        [self close];
    }
}

- (void)close{
    if (self.view.superview){
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [[IQKeyboardManager sharedManager] setEnable:YES];
    }
}

#pragma mark ------UIKeyboardNotification------
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
//    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    self.alertViewCenterY.constant = -keyboardRect.size.height/2;
}

- (void)keyboardWillHide:(NSNotification *)notification {
//    NSDictionary *userInfo = [notification userInfo];
//    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    self.alertViewCenterY.constant = 0;
}

#pragma mark ------UITextViewDelegate------
//最多输入200字限制
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 200){
        textView.text = [textView.text substringToIndex:200];
    }
}

#pragma mark ------UICollectionViewDataSource------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.userList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LinkmanHeadCollectionViewCell *cell = (LinkmanHeadCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:LinkmanHeadCollectionViewCellID forIndexPath:indexPath];
    WYShareLinkmanModel *model = self.userList[indexPath.item];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:AppPlaceholderImage];
    return cell;
}

#pragma mark ------Private------
- (void)setUI{
    WS(weakSelf)
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(40, 40);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 15;
    _headCollectionView.backgroundColor = [UIColor whiteColor];
    _headCollectionView.dataSource = self;
//    _headCollectionView.delegate = self;
    _headCollectionView.scrollsToTop = NO;
    _headCollectionView.showsVerticalScrollIndicator = NO;
    _headCollectionView.showsHorizontalScrollIndicator = NO;
    _headCollectionView.collectionViewLayout = layout;
    [_headCollectionView registerClass:[LinkmanHeadCollectionViewCell class] forCellWithReuseIdentifier:LinkmanHeadCollectionViewCellID];
    
    _headCollectionView.heightChangeBlock = ^(CGFloat height) {
        if (weakSelf.headCollectionViewHeight.constant != height) {
            weakSelf.headCollectionViewHeight.constant = height;
        }
    };
    
    self.alertView.layer.masksToBounds = YES;
    self.alertView.layer.cornerRadius = 4.0;
    
    self.remarkTextView.placeholder = @"添加文字内容";
    self.remarkTextView.placeholderColor = [UIColor colorWithHex:0xC2C2C2];
    
    self.remarkTextView.layer.borderColor = [UIColor colorWithHex:0xE5E5E5].CGColor;
    self.remarkTextView.layer.borderWidth = 0.5;
    self.remarkTextView.layer.cornerRadius = 4.0;
    self.remarkTextView.layer.masksToBounds = YES;
    self.remarkTextView.delegate = self;
    
    if (self.shareTitle.length > 0){
        //分享内容富文本
        NSMutableAttributedString *line1Att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",self.shareTitle] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x868686],
                                                                                                                             NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        UIImage *attachImg = [UIImage imageNamed: @"ic_lianjie_black"];
        textAttachment.image = attachImg;  //设置图片源
        textAttachment.bounds = CGRectMake(0, 0, attachImg.size.width, attachImg.size.height);          //设置图片位置和大小
        NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [line1Att insertAttributedString:attrStr atIndex:0];
        
        self.titleLabel.attributedText = line1Att;
    }
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
