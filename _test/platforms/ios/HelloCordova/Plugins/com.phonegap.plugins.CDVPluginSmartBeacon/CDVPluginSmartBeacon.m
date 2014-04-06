//
//  CDVPluginSmartBeacon.m
//  SmartGap
//
//  Created by Rod H on 2014-03-14.
//
//

#import "CDVPluginSmartBeacon.h"

@implementation CDVPluginSmartBeacon
- (void) initWithIdentifier:(CDVInvokedUrlCommand *)command
{
    NSMutableDictionary* options = (NSMutableDictionary*)[command argumentAtIndex:0];
    NSString *regionIdentifier = [options objectForKey:@"regionIdentifier"];
    
    SBInstanceSingleton *sbInstance = [SBInstanceSingleton sharedInstance];
    [sbInstance addEntireBeaconRegionWithIdentifier:regionIdentifier];
    [sbInstance startServicesForTarget:self];
    
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
- (void) didEnterRegion:(CDVInvokedUrlCommand *)command
{
    NSLog(@"CDVPluginSmartBeacon: subscription to didEnterRegion");
    self.didEnterRegionCallBackId = command.callbackId;
}
- (void) didExitRegion:(CDVInvokedUrlCommand *)command
{
    NSLog(@"CDVPluginSmartBeacon: subscription to didExitRegion");
    self.didExitRegionCallBackId = command.callbackId;
}
- (void) didDiscoverBeacons:(CDVInvokedUrlCommand *)command
{
    NSLog(@"CDVPluginSmartBeacon: subscription to didDiscoverBeacons");
    self.didDiscoverRegionCallBackId = command.callbackId;
}

#pragma mark SBLocationManagerDelegate
- (void)beaconManager:(SBLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if(self.didEnterRegionCallBackId)
    {
        NSLog(@"SBLocationManagerDelegate: did enter region");
        
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSNumber numberWithDouble: region.center.longitude] forKey:@"longitude"];
        [dict setValue:[NSNumber numberWithDouble: region.center.latitude] forKey:@"longitude"];
        [dict setValue:[NSNumber numberWithDouble: region.radius] forKey:@"radius"];
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        
        [result setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:result callbackId:self.didEnterRegionCallBackId];
    }
}

// This method is called when the user exit the listened region.
// It is not immediate, we can wait over 10 seconds before call.
- (void)beaconManager:(SBLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if(self.didExitRegionCallBackId)
    {
        NSLog(@"SBLocationManagerDelegate: did exit region");
        
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSNumber numberWithDouble: region.center.longitude] forKey:@"longitude"];
        [dict setValue:[NSNumber numberWithDouble: region.center.latitude] forKey:@"longitude"];
        [dict setValue:[NSNumber numberWithDouble: region.radius] forKey:@"radius"];
        
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [result setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:result callbackId:self.didExitRegionCallBackId];
    }
}

- (void)beaconManager:(SBLocationManager *)manager didDiscoverBeacons:(NSArray *)beacons inRegion:(CLRegion *)region
{
    if(self.didDiscoverRegionCallBackId && [beacons count])
    {
        CLBeacon *nearestBeacon = [beacons firstObject];
        NSLog(@"Nearest beacon ID: %@ / %@ / %@", [nearestBeacon proximityUUID], [nearestBeacon major], [nearestBeacon minor]);
        
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSNumber numberWithDouble: region.center.longitude] forKey:@"longitude"];
        [dict setValue:[NSNumber numberWithDouble: region.center.latitude] forKey:@"longitude"];
        [dict setValue:[NSNumber numberWithDouble: region.radius] forKey:@"radius"];
        [dict setValue:beacons forKey:@"beacons"];
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [result setKeepCallback:[NSNumber numberWithBool:YES]];


        // Does the callback need to know all beacons discovered or only the nearest ? Y: return `nearestBeacon` as json object / N: return `beacons` as json array
        //NSLog(@"SBLocationManagerDelegate: did discover beacons");
        [result setKeepCallback:[NSNumber numberWithBool:YES]];

        [self.commandDelegate sendPluginResult:result callbackId:self.didDiscoverRegionCallBackId];
    }
}


@end
