//
//  ItemVC.h
//  projectKey
//
//  Created by Сергей Лукоянов on 26.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@protocol ItemVCDelegate <NSObject>

- (void)didSelectItem:(Item *)item;

@end

@interface ItemVC : UIViewController
@property(nonatomic, strong) Item *item;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UITextField *quantTF;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (weak, nonatomic) IBOutlet UIView *textViewCintainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property(nonatomic, weak) id <ItemVCDelegate> delegate;

@property(nonatomic, assign) BOOL isRelatedMode;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *alsoNeedLabel;


@end
