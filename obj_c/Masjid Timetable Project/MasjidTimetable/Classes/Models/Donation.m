//
//  Donation.m
//  Masjid Timetable
//
//  Created by Andranik Asilbekyan on 2/18/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "Donation.h"
//#import "MasjidPrefixHeader.pch"

@implementation Donation

@dynamic created;
@dynamic donationId;
@dynamic live;
@dynamic encouragementText;
@dynamic masjidId;
@dynamic paypalCode;
@dynamic bankDetails;

- (void)setAttributes:(NSDictionary *)attributes
{
    self.masjidId = [[attributes valueForKeyPath:@"masjid_id"] intValue];
    self.donationId = [[attributes valueForKeyPath:@"donation_id"] intValue];
    self.live = [[attributes valueForKeyPath:@"donation_live"] intValue];
    self.encouragementText = [attributes valueForKeyPath:@"encouragement_text"];
    self.paypalCode = NULL_TO_NIL([attributes valueForKeyPath:@"paypal_code"]);
    self.created = [attributes valueForKeyPath:@"donation_created"];
    self.bankDetails = [attributes valueForKeyPath:@"bank_details"];
}

@end
