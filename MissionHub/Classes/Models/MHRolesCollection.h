//
//  MHRolesCollection.h
//  MissionHub
//
//  Created by Michael Harrison on 2/8/13.
//
//

#import <Foundation/Foundation.h>

@interface MHRolesCollection : NSObject <NSCopying>

@property (nonatomic, retain) NSMutableArray *rolesArray;

-(id)initWithArray:(NSMutableArray *)rolesArray;
-(void)addRole:(id)role;

-(id)roleWithID:(NSInteger)roleID;
-(id)roleForIndexPath:(NSIndexPath *)index;

-(void)updateWithArray:(NSMutableArray *)rolesArray;

-(id)removeRoleWithID:(NSInteger)roleID;
-(id)removeRole:(id)role;
-(void)removeAll;

-(BOOL)hasRole:(id)role;
-(NSInteger)count;

@end
