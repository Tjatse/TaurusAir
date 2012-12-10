//
//  MKMapViewAdditions.m
//  FelixSDK
//
//  Created by felix on 12-2-9.
//  Copyright 2012 deep. All rights reserved.
//

#import "MKMapViewAdditions.h"

@implementation MKMapView (MKMapViewAdditions)

- (void)zoomToFitMapAnnotationsAnimated:(BOOL)isAnimated
{
    if ([self.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (id<MKAnnotation> annotation in self.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5 + 0.007f;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fmax(0.01f, fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1); // Add a little extra space on the sides
    region.span.longitudeDelta = fmax(0.01f, fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1); // Add a little extra space on the sides
    
    region = [self regionThatFits:region];
    [self setRegion:region animated:isAnimated];
}

@end
