//
//  MKMapViewAdditions.h
//  FelixSDK
//
//  Created by felix on 12-2-9.
//  Copyright 2012 deep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKMapView (MKMapViewAdditions)

- (void)zoomToFitMapAnnotationsAnimated:(BOOL)isAnimated;

@end
