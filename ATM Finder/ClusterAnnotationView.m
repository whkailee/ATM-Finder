//
//  ClusterAnnotationView.m
//  ATM Finder
//
//  Created by Steven Li on 22/07/16.
//  Copyright © 2016 Xinc. All rights reserved.
//

#import "ClusterAnnotationView.h"

@interface ClusterAnnotationView ()

@property (nonatomic) UILabel *countLabel;

@end

@implementation ClusterAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpLabel];
        [self setCount:1];
    }
    return self;
}

- (void)setUpLabel
{
    _countLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _countLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = [UIColor blackColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.minimumScaleFactor = 2;
    _countLabel.numberOfLines = 1;
    _countLabel.font = [UIFont boldSystemFontOfSize:12];
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    [self addSubview:_countLabel];
}

- (void)setCount:(NSUInteger)count
{
    _count = count;
    if (_count > 1) {
        self.countLabel.text = [@(count) stringValue];
    }
    [self setNeedsLayout];
}

- (void)setIsAtm:(BOOL)isAtm
{
    _isAtm = isAtm;
    [self setNeedsLayout];
}

- (void)setUniqueLocation:(BOOL)uniqueLocation
{
    _uniqueLocation = uniqueLocation;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    // Images are faster than using drawRect:
    UIImage *image;
    CGPoint centerOffset;
    CGRect countLabelFrame;
    if (self.isUniqueLocation) {
        NSString *imageName = nil;
        if (self.isAtm)
        {
            imageName = @"atm_pin";
            centerOffset = CGPointMake(14, -13.25);
        }
        else
        {
            imageName = @"branch_pin";
            centerOffset = CGPointMake(0, -19.5);
        }
        image = [UIImage imageNamed:imageName];
        countLabelFrame = CGRectZero;
    }
    else {
        
        NSString *imageName = @"cluster";
        image = [UIImage imageNamed:imageName];
        
        centerOffset = CGPointZero;
        countLabelFrame = self.bounds;
    }
    
    self.countLabel.frame = countLabelFrame;
    self.image = image;
    self.centerOffset = centerOffset;
}

@end
