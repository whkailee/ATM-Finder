//
//  ClusterAnnotationView.h
//  ATM Finder
//
//  Created by Steven Li on 22/07/16.
//  Copyright © 2016 Xinc. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ClusterAnnotationView : MKAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic) NSUInteger count;
@property (nonatomic, assign) BOOL isAtm;
@property (nonatomic, getter = isUniqueLocation) BOOL uniqueLocation;

@end
