//
//  ViewController.m
//  FMDB_study
//
//  Created by 闫潇 on 15/12/8.
//  Copyright © 2015年 闫潇. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"


#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define DBNAME    @"personinfo.sqlite"
#define ID        @"id"
#define NAME      @"name"
#define AGE       @"age"
#define ADDRESS   @"address"
#define ICON      @"icon"
#define TABLENAME @"User"
@interface ViewController ()
{
    FMDatabase * db;
    NSString * database_path;
}
@property (nonatomic, retain) NSString * dbPath;
@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    
    UIButton *openDBBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect rect=CGRectMake(60, 60, 200, 50);
    openDBBtn.frame=rect;
    [openDBBtn addTarget:self action:@selector(createTable) forControlEvents:UIControlEventTouchDown];
    [openDBBtn setTitle:@"createTable" forState:UIControlStateNormal];
    [self.view addSubview:openDBBtn];
    
    
    UIButton *insterBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect rect2=CGRectMake(60, 130, 200, 50);
    insterBtn.frame=rect2;
    [insterBtn addTarget:self action:@selector(insertData) forControlEvents:UIControlEventTouchDown];
    [insterBtn setTitle:@"insert" forState:UIControlStateNormal];
    [self.view addSubview:insterBtn];
    
    
    UIButton *updateBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect rect3=CGRectMake(60, 200, 200, 50);
    updateBtn.frame=rect3;
    [updateBtn addTarget:self action:@selector(updateData) forControlEvents:UIControlEventTouchDown];
    [updateBtn setTitle:@"update" forState:UIControlStateNormal];
    [self.view addSubview:updateBtn];
    
    UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect rect4=CGRectMake(60, 270, 200, 50);
    deleteBtn.frame=rect4;
    [deleteBtn addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchDown];
    [deleteBtn setTitle:@"delete" forState:UIControlStateNormal];
    [self.view addSubview:deleteBtn];
    
    UIButton *selectBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect rect5=CGRectMake(60, 340, 200, 50);
    selectBtn.frame=rect5;
    [selectBtn addTarget:self action:@selector(selectData) forControlEvents:UIControlEventTouchDown];
    [selectBtn setTitle:@"select" forState:UIControlStateNormal];
    [self.view addSubview:selectBtn];
}
- (void)createTable{
    //sql 语句
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == NO) {
        
        if ([db open]) {
            
            NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'User' ('id' INTEGER PRIMARY KEY AUTOINCREMENT, 'name' text, 'age' text, address text, icon text)"];
            
            BOOL res = [db executeUpdate:sqlCreateTable];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"success to creating db table");
            }
            [db close];
        }
    }
    else {
        debugLog(@"error when open db");
    }
}

-(void) insertData{
    
    static int idx = 1;
    
    if ([db open]) {
        
        NSString *sql= [NSString stringWithFormat:
                               @"INSERT INTO 'User' ('name', 'age', 'address', 'icon') VALUES (?, ?, ?, ?)"];
        
        NSString * name = [NSString stringWithFormat:@"潇%d", idx++];
        BOOL res = [db executeUpdate:sql, name, @"18",@"🌍",[NSString stringWithFormat:@"%@",self.dbPath]];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        [db close];
        
    }

}
//update stu set name='%@' where name='%@'",@"我被修改了",name
-(void) updateData{
    if ([db open]) {
        NSString *updateSql = [NSString stringWithFormat:
                               
                               @"UPDATE User SET age = '%@' WHERE name = '%@' ",@"17",@"潇1"];
        BOOL res = [db executeUpdate:updateSql];
        if (!res) {
            NSLog(@"error when update db table");
        } else {
            NSLog(@"success to update db table");
        }
        [db close];
        
    }
}

-(void) deleteData{
    if ([db open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where %@ = '%@'",
                               TABLENAME, NAME, @"潇1"];
        BOOL res = [db executeUpdate:deleteSql];
        
        if (!res) {
            NSLog(@"error when delete db table");
        } else {
            NSLog(@"success to delete db table");
        }
        [db close];
        
    }
    
}



-(void) selectData{
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",TABLENAME];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int Id = [rs intForColumn:ID];
            NSString * name = [rs stringForColumn:NAME];
            NSString * age = [rs stringForColumn:AGE];
            NSString * address = [rs stringForColumn:ADDRESS];
            NSString * iconPath = [rs stringForColumn:ICON];
            NSLog(@"id = %d, name = %@, age = %@  address = %@ icon = %@" , Id, name, age, address,iconPath);
        }
        [db close];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * doc = PATH_OF_DOCUMENT;
    NSString * path = [doc stringByAppendingPathComponent:@"user.sqlite"];
    self.dbPath = path;
    
    db =  [FMDatabase databaseWithPath:self.dbPath];
}



@end
