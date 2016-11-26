//
//  TableViewCell.m
//  projectKey
//
//  Created by Сергей Лукоянов on 25.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import "TableViewCell.h"



@interface TableViewCell ()



@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self configureCell];
}

- (void)configureCell {
    NSArray *arr = @[_plusButton, _minusButton];
    
    UIColor *blue;
    
    for (UIButton *b in arr ) {
        CALayer *l = b.layer;
        blue = b.tintColor;
        l.borderColor = b.tintColor.CGColor;
        l.cornerRadius = b.frame.size.width / 2;
        l.borderWidth = 1;
    }
    
//    CALayer *l = _photoIV.layer;
//    l.borderColor = blue.CGColor;
//    l.cornerRadius = 4;
//    l.borderWidth = 1;
//    l.cornerRadius = _photoIV.frame.size.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)plusButtonTapped:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(plusButtonTappedInCell:)]) {
        [_delegate plusButtonTappedInCell:self];
    }
}

- (IBAction)minusButtonTapped:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(minusButtonTappedInCell:)]) {
        [_delegate minusButtonTappedInCell:self];
    }
}

- (IBAction)mainButtonTapped:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectCell:)]) {
        [_delegate didSelectCell:self];
    }
}





@end
