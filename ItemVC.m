//
//  ItemVC.m
//  projectKey
//
//  Created by Сергей Лукоянов on 26.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import "ItemVC.h"



@interface ItemVC () {
    CAGradientLayer *gradient;
}

@end

@implementation ItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureTextView];
    [self configureButtons];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

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
    NSArray *arr = @[_plusButton, _minusButton];
    
    for (UIButton *b in arr ) {
        CALayer *l = b.layer;
        l.borderColor = b.tintColor.CGColor;
        l.cornerRadius = b.frame.size.width / 2;
        l.borderWidth = 1;
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
