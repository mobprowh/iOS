//
//  MTDBHelper.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

#import "MTDBHelper.h"
#import "Constants.h"

@interface MTDBHelper ()

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation MTDBHelper

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)sharedDBHelper {
    static MTDBHelper *_sharedDBHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDBHelper = [MTDBHelper new];
    });
    
    return _sharedDBHelper;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            //            abort();
        }
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MTDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MT"];
  storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:AppGroupsID];
  storeURL = [storeURL URLByAppendingPathComponent:@"MT"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        //        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data Helper methods

- (Masjid*)createMasjidWithAttributes:(NSDictionary *)attributes
{
    Masjid *masjid = [NSEntityDescription insertNewObjectForEntityForName:@"Masjid" inManagedObjectContext:self.managedObjectContext];
    [masjid setAttributes:attributes];
    
    [self saveContext];
    
    return masjid;
}

- (Masjid*)updateMasjidWithAttributes:(NSDictionary *)attributes
{
    Masjid *masjid = [self getMasjidWithID:[attributes valueForKeyPath:@"masjid_id"]];
    if (masjid) {
        NSString *favorie = masjid.favorite;
        [masjid setAttributes:attributes];
        [masjid setFavorite:favorie];
        
        [self saveContext];
    }
    
    return masjid;
}

- (Masjid*)getMasjidWithID:(NSString*)ID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Masjid" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"masjidId == %@", ID];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

- (Masjid*)getFavoritMasjidByPriority:(NSString*)priority
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Masjid" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite == %@", priority];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

- (Masjid*)getMasjidByName:(NSString *)name
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Masjid" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

- (NSArray*)searchMasjids:(NSString *) keyword
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Masjid" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    
    NSString *matchString =  [NSString stringWithFormat: @".*\\b%@.*",keyword];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@) or (localArea MATCHES[c] %@) or (largerArea MATCHES[c] %@)", keyword, matchString, matchString];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
}

- (void)removeAllMasjids
{
    NSFetchRequest * allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:@"Masjid" inManagedObjectContext:self.managedObjectContext]];
    [allCars setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * cars = [self.managedObjectContext executeFetchRequest:allCars error:&error];
    //error handling goes here
    for (NSManagedObject * car in cars) {
        [self.managedObjectContext deleteObject:car];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

- (NSArray*)getMasjids
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Masjid" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError* error;
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
}


- (void)addMasjids:(NSArray*)response
{
    for (NSDictionary *attributes in response) {
        [self createMasjidWithAttributes:attributes];
    }
}

- (void)updateMasjids:(NSArray*)response
{
    
    for (NSDictionary *attributes in response) {
        [self updateMasjidWithAttributes:attributes];
    }
}

- (MasjidTimetable*)createTimetableWithAttributes:(NSDictionary *)attributes forMasjid:(int)masjidId
{
    MasjidTimetable *timetable = [NSEntityDescription insertNewObjectForEntityForName:@"MasjidTimetable" inManagedObjectContext:self.managedObjectContext];
    [timetable setAttributes:attributes];
    [timetable setMasjidId:masjidId];
    
    [self saveContext];
    
    return timetable;
}

- (void)createTimetableForCurrentMonthWithAttributes:(NSDictionary *)attributes forMasjid:(int)masjidId
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"d-MM-yyyy"];
    NSDate *date =  [dateFormatter dateFromString:[attributes valueForKeyPath:@"DATE"]];
    if ([date timeIntervalSinceDate:[Utils getCurrenMonthFirstDay]] > 0 && [date timeIntervalSinceDate:[Utils getCurrentMonthLastDay]] < 0) {
        MasjidTimetable *timetable = [NSEntityDescription insertNewObjectForEntityForName:@"MasjidTimetable" inManagedObjectContext:self.managedObjectContext];
        [timetable setAttributes:attributes];
        [timetable setMasjidId:masjidId];
        
        [self saveContext];
    }
}

- (MasjidTimetable*)updateTimetableWithAttributes:(NSDictionary *)attributes forMasjid:(int)masjidId
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"d-MM-yyyy"];
    NSDate *date = [dateFormatter dateFromString:[attributes valueForKeyPath:@"DATE"]];
    MasjidTimetable *timetable = [self getTimetableWithMashjidID:masjidId forDate:date];
    
    if (timetable) {
        [timetable setAttributes:attributes];
        
        [self saveContext];
    }
    
    return timetable;
}

- (MasjidTimetable*)getTimetableWithMashjidID:(int)ID forDate:(NSDate*)date
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasjidTimetable" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(masjidId == %i) AND (date == %@)", ID, date];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

- (MasjidTimetable*)getLatestTimeTablewithID:(int)Id
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasjidTimetable" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(masjidId == %i)", Id];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords lastObject];
    }
    
    return nil;
}

- (MasjidTimetable*)getLastestTimetableWithMashjidID:(int)ID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasjidTimetable" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"date"];
    NSExpression *maxDateExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"maxDate"];
    [expressionDescription setExpression:maxDateExpression];
    [expressionDescription setExpressionResultType:NSDateAttributeType];
    
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    NSError *error;
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

- (void)addTimetables:(NSArray*)response forMasjid:(int)masjidId
{
    for (NSDictionary *attributes in response) {
        [self createTimetableWithAttributes:attributes forMasjid:masjidId];
    }
}

- (void)updateTimetables:(NSArray*)response forMasjid:(int)masjidId
{
    for (NSDictionary *attributes in response) {
        MasjidTimetable *timetable = [self updateTimetableWithAttributes:attributes forMasjid:masjidId];
        if (!timetable) {
            [self createTimetableWithAttributes:attributes forMasjid:masjidId];
        }
    }
}

- (void)updateCurrentMonthTimetables:(NSArray*)response forMasjid:(int)masjidId
{
    for (NSDictionary *attributes in response) {
        [self createTimetableForCurrentMonthWithAttributes:attributes forMasjid:masjidId];
    }
}

- (void)removeMasjidAllTimeTablesForMasjidId:(int)masjidId
{
    NSArray *currentmasjidTimeTables = [self getMasjidTimeTablesWithMasjidId:masjidId];
    //error handling goes here
    for (MasjidTimetable *timeTable in currentmasjidTimeTables) {
        [self.managedObjectContext deleteObject:timeTable];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

- (void)removeCurrentMounthTimeTablesForMasjidId:(int)masjidId
{
    NSArray *currentMounthTimeTables = [self getMasjidTimeTablesForCurrentMounthWithMasjidId:masjidId];
    
    for (MasjidTimetable *timeTable in currentMounthTimeTables) {
        [self.managedObjectContext deleteObject:timeTable];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

- (NSArray*)getMasjidTimetablesToDate:(NSDate*)date forMasjid:(int)masjidId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasjidTimetable" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"d-MM-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *today = [dateFormatter dateFromString:dateString];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(masjidId == %i) AND (date >= %@) AND (date <= %@)", masjidId, today, date];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
}

- (NSArray *)getMasjidTimeTablesWithMasjidId:(int)masjidId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasjidTimetable" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"d-MM-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *today = [dateFormatter dateFromString:dateString];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(masjidId == %i) AND (date >= %@)", masjidId, today];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
}

- (NSArray *)getMasjidTimeTablesForCurrentMounthWithMasjidId:(int)masjidId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasjidTimetable" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(masjidId == %i) AND (date >= %@) AND (date <= %@)", masjidId, [Utils getCurrenMonthFirstDay], [Utils getCurrentMonthLastDay]];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
}

- (Ramadhan*)createRamadhanWithAttributes:(NSDictionary *)attributes forMasjid:(int)masjidId
{
    Ramadhan *ramadhan = [NSEntityDescription insertNewObjectForEntityForName:@"Ramadhan" inManagedObjectContext:self.managedObjectContext];
    [ramadhan setAttributes:attributes];
    [ramadhan setMasjidId:masjidId];
    
    [self saveContext];
    
    return ramadhan;
}

- (Ramadhan*)updateRamadhanWithAttributes:(NSDictionary *)attributes forMasjid:(int)masjidId
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"d-MM-yy"];
    NSDate *date = [dateFormatter dateFromString:[attributes valueForKeyPath:@"DATE"]];
    Ramadhan *ramadhan = [self getRamadhanWithMashjidID:masjidId forDate:date];
    
    if (ramadhan) {
        [ramadhan setAttributes:attributes];
        
        [self saveContext];
    }
    
    return ramadhan;
}

- (Ramadhan*)getRamadhanWithMashjidID:(int)ID forDate:(NSDate*)date
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Ramadhan" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(masjidId == %i) AND (date == %@)", ID, date];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

- (void)updateRamadhans:(NSArray*)response forMasjid:(int)masjidId
{
    for (NSDictionary *attributes in response) {
        Ramadhan *ramadhan = [self updateRamadhanWithAttributes:attributes forMasjid:masjidId];
        if (!ramadhan) {
            [self createRamadhanWithAttributes:attributes forMasjid:masjidId];
        }
    }
}

- (NSArray*)getRamadhansWithMashjidID:(int)ID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Ramadhan" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"d-MM-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *today = [dateFormatter dateFromString:dateString];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(masjidId == %i) AND (date >= %@)", ID, today];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
}

- (void)removeAllRamadhansForMasjidId:(int)masjidId
{
    NSArray *ramadhans = [self getRamadhansWithMashjidID:masjidId];
    
    for (Ramadhan *ramadhan in ramadhans) {
        [self.managedObjectContext deleteObject:ramadhan];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

- (Event*)createEventWithAttributes:(NSDictionary *)attributes
{
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [event setAttributes:attributes];
    
    [self saveContext];
    
    return event;
}

- (Event*)updateEventWithAttributes:(NSDictionary *)attributes
{
    Event *event = [self getEventWithID:[attributes valueForKeyPath:@"event_id"]];
    if (event) {
        [event setAttributes:attributes];
        
        [self saveContext];
    }
    
    return event;
}

- (void)updateEvents:(NSArray*)response
{
    for (NSDictionary *attributes in response) {
        Event *event = [self updateEventWithAttributes:attributes];
        if (!event) {
            [self createEventWithAttributes:attributes];
        }
    }
}

- (Event*)getEventWithID:(NSString*)ID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventId == %@", ID];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

- (NSArray*)getEvents:(int)masjidId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *today = [dateFormatter dateFromString:dateString];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(masjidId == %i) AND (longDate >= %@)", masjidId, today];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"longDate" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
}

- (void)removeAllEventsForMasjidId:(int)masjidId
{
    NSArray *events = [self getEvents:masjidId];
    
    for (Event *event in events) {
        [self.managedObjectContext deleteObject:event];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

- (Donation*)createDonationWithAttributes:(NSDictionary *)attributes
{
    Donation *donation = [NSEntityDescription insertNewObjectForEntityForName:@"Donation" inManagedObjectContext:self.managedObjectContext];
    [donation setAttributes:attributes];
    
    [self saveContext];
    
    return donation;
}

- (Donation*)updateDonationWithAttributes:(NSDictionary *)attributes
{
    Donation *donation = [self getDonationWithID:[attributes valueForKeyPath:@"donation_id"]];
    if (donation) {
        [donation setAttributes:attributes];
        
        [self saveContext];
    }
    
    return donation;
}

- (void)updateDonations:(NSArray*)response
{
    for (NSDictionary *attributes in response) {
        Donation *donation = [self updateDonationWithAttributes:attributes];
        if (!donation) {
            [self createDonationWithAttributes:attributes];
        }
    }
}

- (Donation*)getDonationWithID:(NSString*)ID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Donation" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"donationId == %@", ID];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

- (NSArray*)getDonations:(int)masjidId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Donation" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"masjidId == %i", masjidId];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
}

- (void)removeAllDonationsForMasjidId:(int)masjidId
{
    NSArray *donations = [self getDonations:masjidId];
    
    for (Donation *donation in donations) {
        [self.managedObjectContext deleteObject:donation];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

- (Note*)createNoteWithAttributes:(NSDictionary *)attributes
{
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    [note setAttributes:attributes];
    
    [self saveContext];
    
    return note;
}

- (Note*)updateNoteWithAttributes:(NSDictionary *)attributes
{
    Note *note = [self getNoteWithID:[attributes valueForKeyPath:@"note_id"]];
    if (note) {
        [note setAttributes:attributes];
        
        [self saveContext];
    }
    
    return note;
}

- (void)updateNotes:(NSArray*)response
{
    for (NSDictionary *attributes in response) {
        Note *note = [self updateNoteWithAttributes:attributes];
        if (!note) {
            [self createNoteWithAttributes:attributes];
        }
    }
}

- (Note*)getNoteWithID:(NSString*)ID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"noteId == %@", ID];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

- (NSArray*)getNotes:(int)masjidId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"masjidId == %i", masjidId];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *notes = [NSMutableArray array];
    if (fetchedRecords && [fetchedRecords count] > 0) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:[NSDate date]];
        NSInteger currentMonth = [components month];
        
        for (Note *note in fetchedRecords) {
            NSArray *components = [note.month componentsSeparatedByString:@","];
            for (NSString *month in components) {
                if ([month intValue] == currentMonth) {
                    [notes addObject:note];
                    break;
                }
            }
        }
        
    }
    
    return notes;
}

- (void)removeAllNotesForMasjidId:(int)masjidId
{
    NSArray *notes = [self getNotes:masjidId];
    
    for (Note *note in notes) {
        [self.managedObjectContext deleteObject:note];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

- (TimeTableFormat*)createTimeTableFormatWithAttributes:(NSDictionary *)attributes
{
    TimeTableFormat *timeTableFormat = [NSEntityDescription insertNewObjectForEntityForName:@"TimeTableFormat" inManagedObjectContext:self.managedObjectContext];
    [timeTableFormat setAttributes:attributes];
    
    [self saveContext];
    
    return timeTableFormat;
}

- (TimeTableFormat*)updateTimeTableFormatWithAttributes:(NSDictionary *)attributes
{
    TimeTableFormat *timeTableFormat = [self getTimeTableFormatWithID:[attributes valueForKeyPath:@"timetable_id"]];
    if (timeTableFormat) {
        [timeTableFormat setAttributes:attributes];
        
        [self saveContext];
    }
    
    return timeTableFormat;
}

- (void)updateTimeTableFormats:(NSArray*)response
{
    for (NSDictionary *attributes in response) {
        TimeTableFormat *timeTableFormat = [self updateTimeTableFormatWithAttributes:attributes];
        if (!timeTableFormat) {
            [self createTimeTableFormatWithAttributes:attributes];
        }
    }
}

- (TimeTableFormat*)getTimeTableFormatWithID:(NSString*)ID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimeTableFormat" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timetableformatId == %@", ID];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

- (NSArray*)getTimeTableFormats:(int)masjidId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimeTableFormat" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *today = [dateFormatter dateFromString:dateString];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(masjidId == %i) AND (month >= %@)", masjidId, today];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"month" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
}

- (TimeTableFormat*)getTimeTableFormat:(int)masjidId forDate:(NSDate *)date
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimeTableFormat" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDateComponents *components = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date];
    components.day = 1;
    
    NSDate *currentmonthFirstDay = [calendar dateFromComponents:components];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(masjidId == %i) AND (month == %@)", masjidId, currentmonthFirstDay];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"month" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    return nil;
}

- (TimeTableFormat*)getCurrentMontTimeTableFormat:(int)masjidId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimeTableFormat" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDateComponents *components = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
    components.day = 1;
    
    NSDate *currentmonthFirstDay = [calendar dateFromComponents:components];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(masjidId == %i) AND (month == %@)", masjidId, currentmonthFirstDay];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"month" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

- (void)removeAllTimeTablesFormatForMasjidId:(int)masjidId
{
    NSArray *timeTableFormats = [self getTimeTableFormats:masjidId];
    for (TimeTableFormat *timeTableFormat in timeTableFormats) {
        [self.managedObjectContext deleteObject:timeTableFormat];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

- (JammatSoundSettings *)createJammatSoundSettings
{
    JammatSoundSettings *jammatSoundSettings = [NSEntityDescription insertNewObjectForEntityForName:@"JammatSoundSettings" inManagedObjectContext:self.managedObjectContext];
    
    [self saveContext];
    
    return jammatSoundSettings;
}

- (JammatSoundSettings *)getJammatSoundSettings
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JammatSoundSettings" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

- (BeginnerSoundSettings *)createBeginnerSoundSettings{
  
  BeginnerSoundSettings *beginnerSoundSettings = [NSEntityDescription insertNewObjectForEntityForName:@"BeginnerSoundSettings" inManagedObjectContext:self.managedObjectContext];
  
  [self saveContext];
  
  return beginnerSoundSettings;

}
- (BeginnerSoundSettings *)getBeginnerSoundSettings
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"BeginnerSoundSettings" inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  NSError* error;
  
  NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
  if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
    return [fetchedRecords objectAtIndex:0];
  }
  
  return nil;
}

- (PhoneMuteSettings *)createPhoneMuteSettings
{
    PhoneMuteSettings *phoneMuteSettings = [NSEntityDescription insertNewObjectForEntityForName:@"PhoneMuteSettings" inManagedObjectContext:self.managedObjectContext];
    
    [self saveContext];
    
    return phoneMuteSettings;
}

- (PhoneMuteSettings *)getPhoneMuteSettings
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PhoneMuteSettings" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

#pragma  mark - Issue model functions

- (Issue*)createIssueWithAttributes:(NSDictionary *)attributes
{
    Issue *issue = [NSEntityDescription insertNewObjectForEntityForName:@"Issue" inManagedObjectContext:self.managedObjectContext];
    [issue setAttributes:attributes];
    
    [self saveContext];
    
    return issue;
}

- (Issue*)updateIssueWithAttributes:(NSDictionary *)attributes
{
    Issue *issue = [self getIssueWithID:[attributes valueForKeyPath:@"page_id"]];
    if (issue) {
        [issue setAttributes:attributes];
    } else {
      issue = [self createIssueWithAttributes:attributes];
    }
    
    [self saveContext];

    return issue;
}

- (Issue*)getIssueWithID:(NSString*)ID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Issue" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pageId == %@", ID];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

- (NSArray*)searchIssues:(NSString *) keyword
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Issue" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@)", keyword];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
}


- (NSArray*)getIssues
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Issue" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
}


- (void)addIssues:(NSArray *)response
{
    for (NSDictionary *attributes in response) {
        [self createIssueWithAttributes:attributes];
    }
}

- (void)updateIssues:(NSArray*)response
{
    for (NSDictionary *attributes in response) {
        [self updateIssueWithAttributes:attributes];
    }
}

- (void)removeAllIssues
{
    NSFetchRequest * allIssue = [[NSFetchRequest alloc] init];
    [allIssue setEntity:[NSEntityDescription entityForName:@"Issue" inManagedObjectContext:self.managedObjectContext]];
    [allIssue setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * issues = [self.managedObjectContext executeFetchRequest:allIssue error:&error];
    //error handling goes here
    for (NSManagedObject * issue in issues) {
        [self.managedObjectContext deleteObject:issue];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

#pragma mark - Instructions model functionallity

- (Instruction*)createInstructionWithAttributes:(NSDictionary *)attributes
{
    Instruction *instuction = [NSEntityDescription insertNewObjectForEntityForName:@"Instruction" inManagedObjectContext:self.managedObjectContext];
    [instuction setAttributes:attributes];
    
    [self saveContext];
    
    return instuction;
}

- (Instruction*)updateInstructionWithAttributes:(NSDictionary*)attributes
{
    Instruction *instuction = [self getInstructionWithID:[attributes valueForKeyPath:@"page_id"]];
    if (instuction) {
        [instuction setAttributes:attributes];
    } else {
        instuction = [self createInstructionWithAttributes:attributes];
    }
    
    [self saveContext];
    
    return instuction;
}

- (Instruction*)getInstructionWithID:(NSString*)ID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Instruction" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pageId == %@", ID];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedRecords && [fetchedRecords count] > 0 && [fetchedRecords objectAtIndex:0]) {
        return [fetchedRecords objectAtIndex:0];
    }
    
    return nil;
}

- (NSArray*)searchInstructions:(NSString *) keyword
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Instruction" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@) AND (status == %@)", keyword, @"1"];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
}


- (NSArray*)getInstructions
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Instruction" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedRecords;
}


- (void)addInstruction:(NSArray *)response
{
    for (NSDictionary *attributes in response) {
        [self createInstructionWithAttributes:attributes];
    }
}

- (void)updateInstruction:(NSArray*)response
{
    for (NSDictionary *attributes in response) {
        [self updateInstructionWithAttributes:attributes];
    }
}

- (void)removeAllInstructions
{
    NSFetchRequest * allInstruction = [[NSFetchRequest alloc] init];
    [allInstruction setEntity:[NSEntityDescription entityForName:@"Instruction" inManagedObjectContext:self.managedObjectContext]];
    [allInstruction setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * issues = [self.managedObjectContext executeFetchRequest:allInstruction error:&error];
    //error handling goes here
    for (NSManagedObject * instruction in issues) {
        [self.managedObjectContext deleteObject:instruction];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

@end
