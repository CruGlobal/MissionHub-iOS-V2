//
//  MHRolesCollection.m
//  MissionHub
//
//  Created by Michael Harrison on 2/8/13.
//
//

#import "MHRolesCollection.h"

@implementation MHRolesCollection

@synthesize rolesArray;

-(id)initWithArray:(NSMutableArray *)roles {
	
	if (self = [super init]) {
		
		self.rolesArray = roles;
		
	}
	
	if (self.rolesArray == nil) {
		
		self.rolesArray = [NSMutableArray array];
		
	}
	
	return self;
	
}

-(id)copyWithZone:(NSZone *)zone {
	
	MHRolesCollection *copiedCollection	= [[MHRolesCollection alloc] initWithArray:nil];
	
	for (id role in self.rolesArray) {
		
		[copiedCollection addRole:[role copyWithZone:zone]];
		
	}
	
	return copiedCollection;
	
}

-(void)addRole:(id)role {
	
	if (self.rolesArray == nil) {
		
		self.rolesArray = [NSMutableArray array];
		
	}
	
	[self.rolesArray addObject:role];
	
}

-(id)roleWithID:(NSInteger)roleID {
	
	if (self.rolesArray == nil) {
		
		return nil;
		
	}
	
	for (NSDictionary *role in self.rolesArray) {
		
		if ([[role objectForKey:@"id"] integerValue] == roleID) {
			
			return role;
			
		}
		
	}
	
	return nil;
	
}

-(id)roleForIndexPath:(NSIndexPath *)index {
	
	if (self.rolesArray == nil || index.row < 0 || index.row > self.rolesArray.count) {
		
		return nil;
		
	}
	
	return [self.rolesArray objectAtIndex:index.row];
	
}

-(void)updateWithArray:(NSMutableArray *)roles {
	
	self.rolesArray = roles;
	
	if (self.rolesArray == nil) {
		
		self.rolesArray = [NSMutableArray array];
		
	}
	
}

-(id)removeRoleWithID:(NSInteger)roleID {
	
	if (self.rolesArray == nil) {
		
		return nil;
		
	}
	
	for (NSDictionary *role in self.rolesArray) {
		
		if ([[role objectForKey:@"id"] integerValue] == roleID) {
			
			[self.rolesArray removeObject:role];
			
			return role;
			
		}
		
	}
	
	return nil;
	
}

-(id)removeRole:(id)role {
	
	if (self.rolesArray == nil) {
		
		return nil;
		
	}
	
	[self.rolesArray removeObject:role];
	
	return nil;
	
}

-(void)removeAll {
	
	if (self.rolesArray == nil) {
		
		return;
		
	}
	
	[self.rolesArray removeAllObjects];
	
}

-(BOOL)hasRole:(id)role {
	
	if (self.rolesArray == nil) {
		
		return NO;
		
	}
	
	return [self.rolesArray containsObject:role];
	
}

-(NSInteger)count {
	
	if (self.rolesArray == nil) {
		
		return 0;
		
	}
	
	return self.rolesArray.count;
}

@end
