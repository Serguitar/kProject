//
//  ItemVC.m
//  projectKey
//
//  Created by Сергей Лукоянов on 26.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import "ItemVC.h"
#import "CollectionCell.h"
#import <EHPlainAlert/EHPlainAlert.h>
#import "CardRouter.h"
#import <SDWebImage/UIImageView+WebCache.h>



@interface ItemVC () <UICollectionViewDelegate, UICollectionViewDataSource> {
    CAGradientLayer *gradient;
    NSArray *arr;
    BOOL shouldClose;
}

@end

@implementation ItemVC

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureTextView];
    [self configureButtons];
    

    
    arr = @[ @1, @2, @3, @4];
    
    if (_isRelatedMode) {
        [_collectionView setHidden:YES];
        [_alsoNeedLabel setHidden:YES];
    }
    
    [_minusButton setEnabled:YES];
    
    _titleLabel.text = _item.name;
    _textView.text = _item.shortDescr;
    _priceLabel.text =  [NSString stringWithFormat:@"%.1f €", _item.cost];

    
    if (_item.photoLink) {
        NSURL *url = [NSURL URLWithString:_item.photoLink];
        [_imageIV sd_setImageWithURL:url
                        placeholderImage:nil];
        
    }

    
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(close) name:@"CLOSE" object:nil];

}

//TableViewCellDeelgate
- (IBAction)plusButtonTapped {
    _item.quantity += 1;
    _quantTF.text = [NSString stringWithFormat:@"%lu",(unsigned long)_item.quantity];
     [_minusButton setEnabled:YES];
}

- (IBAction)minusButtonTapped {
    NSUInteger quant = _item.quantity - 1;
    if (quant > 0) {
        _item.quantity = quant;
        _quantTF.text = [NSString stringWithFormat:@"%lu",(unsigned long)_item.quantity];
        [_minusButton setEnabled:YES];
    } else {
        [_minusButton setEnabled:NO];
    }
}

- (void)close {
    if (_isRelatedMode) {
        shouldClose = YES;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (shouldClose) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)configureTextView {
    gradient = [CAGradientLayer layer];
    
    gradient.frame = self.textView.superview.bounds;
    gradient.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor];
    gradient.locations = @[@0.0, @0.03, @0.3, @1.0];
    
    self.textView.superview.layer.mask = gradient;
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTapped:)];
    [_textView addGestureRecognizer:gestureRecognizer];
}

- (void)configureButtons {
    NSArray *array = @[_plusButton, _minusButton];
    
    UIColor *blueColor;
    for (UIButton *b in array ) {
        CALayer *l = b.layer;
        l.borderColor = b.tintColor.CGColor;
        l.cornerRadius = b.frame.size.height / 2;
        l.borderWidth = 1;
        blueColor = b.tintColor;
    }
    
    NSArray *buttons = @[_addButton, _buyNowButton];
    for (UIButton *b in buttons ) {
        CALayer *l = b.layer;
//        l.borderColor = blueColor.CGColor;
        l.cornerRadius = b.frame.size.height / 2;
//        l.borderWidth = 1;
    }

}

- (void)textViewTapped:(id)sender {
    NSLog(@"tapped");
    
    if (self.textView.superview.layer.mask ) {
        [_textViewCintainer removeConstraint:_textViewHeightConstraint];
        self.textView.superview.layer.mask = nil;
    } else {
        self.textView.superview.layer.mask = gradient;
        [_textViewCintainer addConstraint:_textViewHeightConstraint];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didAddItem:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectItem:)]) {
        [_delegate didSelectItem:_item];
        [self.navigationController popViewControllerAnimated:YES];
        
        if (_isRelatedMode) {
            [EHPlainAlert showAlertWithTitle:@"Added to cart" message:nil type:ViewAlertSuccess];
        }
    }
}


//UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdenfier = @"cell";
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdenfier forIndexPath:indexPath];
    return cell;
}

// UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ItemVC *dest = [storyboard instantiateViewControllerWithIdentifier:@"ItemVC_SID"];
    dest.isRelatedMode = YES;
    dest.delegate = _delegate;
    
    Item *item = [Item new];
    item.name = @"test";
    item.cost = 70;
    item.quantity = 1;
    dest.item = item;
    
    [self.navigationController pushViewController:dest animated:YES];
}

- (IBAction)buyNowTapped:(id)sender {
    CGFloat price = 0;
    price = _item.cost * _item.quantity;
    NSString *str = [NSString stringWithFormat:@"%.1f €", price];
    [CardRouter showCardOnVC:self fromItem:YES price:str];
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
