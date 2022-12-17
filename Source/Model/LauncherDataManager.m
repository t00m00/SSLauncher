//
//  LauncherDataManager.m
//  SSLauncher
//
//  Created by toomoo on 2014/08/29.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "LauncherDataManager.h"
#import "LauncherDataManager+Managing.h"
#import "LauncherDataManager+Favorite.h"

#import "TMFileManager.h"
#import "LauncherData+Managing.h"

#import <SSLExtensionLib/SSLShardFileManager.h>
#import "WidgetListData+Converting.h"


static LauncherDataManager *sharedInstance = nil;

/** 
 * @brief ランチャー設定ファイルを読み込んで保持します
 * @note
 *        シングルトンです
 */
@interface LauncherDataManager()

@property (strong, nonatomic) NSMutableArray *datas;                            /**< Launcherデータのすべてを保持 */
@property (strong, nonatomic) LauncherData *processingData;                     /**< 処理中のデータを保持 */

@end

#pragma mark -
#pragma mark ***** LauncherDataManager Class *****
@implementation LauncherDataManager

#pragma mark -
#pragma mark ===== Class Method =====

+ (instancetype)shared
{
	
	static dispatch_once_t once;
	dispatch_once( &once, ^{
		sharedInstance = [[self alloc] init];
        [sharedInstance loadDatas];
	});
    
	return sharedInstance;
}

+ (instancetype)allocWithZone:(NSZone *)zone
{
	
	__block id ret = nil;
	
	static dispatch_once_t once;
	dispatch_once( &once, ^{
		sharedInstance = [super allocWithZone:zone];
		ret = sharedInstance;
	});
	
	return  ret;
}

#pragma mark -
#pragma mark ===== Instance Method =====

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.datas = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return self;
}

- (LauncherData *)objectAtIndex:(NSUInteger)index
{
    return [self.datas objectAtIndex:index];
}

- (void)removeObject:(LauncherData *)data
{
    BOOL ret = [TMFileManager removeLauncherDataFile:[data launcherDataFileName]];
    
    if (ret == YES) {
        
        [self.datas removeObject:data];
        [self updataSortValue];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    LauncherData * const data = [self.datas objectAtIndex:index];
    
    BOOL ret = [TMFileManager removeLauncherDataFile:[data launcherDataFileName]];
    
    if (ret == YES) {
        
        [self.datas removeObjectAtIndex:index];
        [self updataSortValue];
    }
}

- (NSUInteger)count
{
    return [self.datas count];
}

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    LauncherData *fromData = [self objectAtIndex:fromIndex];
    [self removeObject:fromData];
    [self insertObject:fromData atIndex:toIndex];
    
    [self updataSortValue];
}


- (void)reloadData
{
    [self.datas removeAllObjects];
    [self loadDatas];
    [self updateWidgetListDatas];
}

#pragma mark -
#pragma mark ===== Private Instance Method =====
/** 挿入 */
- (void)insertObject:(LauncherData *)data atIndex:(NSUInteger)index
{
    [self.datas insertObject:data atIndex:index];
}

/** LauncherDataファイルの読み込み */
- (void)loadDatas
{
    NSArray *dataPaths = [TMFileManager lancherDataFileNames];
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_t group = dispatch_group_create();
    
    for (NSString* fileName in dataPaths) {
        
//        dispatch_group_async(group, queue, ^{
    
            NSDictionary *dataDic = [TMFileManager readLauncherDataFromFileName:fileName];
            
            if (dataDic != nil) {
                
                [self.datas addObject:[LauncherData create:dataDic]];
            }
            
//        });
    }
    
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER); //(a)

    [self sortWithSortValueAscending];
}

/** ソートバリューを正しい値にする */
- (void)updataSortValue
{
    [self.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        LauncherData *data = (LauncherData *)obj;
        data.sortValue = idx + 1;
    
        [TMFileManager saveLauncherData:[data dataDictionary]
                           withFileName:[data launcherDataFileName]];
    }];
}

/** ソートバリューで降順にソートします */
- (void)sortWithSortValueAscending
{
    NSArray *resultArry =
    [self.datas sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        LauncherData * const data1 = (LauncherData *)obj1;
        LauncherData * const data2 = (LauncherData *)obj2;
        
        if (data1.sortValue > data2.sortValue) {
            
            return NSOrderedDescending;
            
        } else if (data2.sortValue > data1.sortValue) {
            
            return NSOrderedAscending;
            
        }
        
        return NSOrderedSame;
    }];
    
    self.datas = [NSMutableArray arrayWithArray:resultArry];
}

@end


#pragma mark -
#pragma mark ***** LauncherDataManager (Managing) Class *****
@implementation LauncherDataManager (Managing)

/** 連携中のデータを保持します */
- (void)setProcessingObject:(LauncherData *)data
{
    self.processingData = data;
}

- (LauncherData *)processingObject
{
    return self.processingData;
}

@end

#pragma mark -
#pragma mark ***** LauncherDataManager (Favorite) Class *****

/** 基本的にこのカテゴリのメソッドを呼ぶと毎回お気に入りデータの配列を再作成する(処理速度を気にする場合は注意) */
@implementation LauncherDataManager (Favorite)

- (LauncherData *)objectAtIndexOfFavorite:(NSUInteger)index
{
    return [[self sortWithFavoriteSortValueAscending] objectAtIndex:index];
}

- (NSUInteger)countOfFavorite
{
    return [[self datasOfFavorite] count];
}

- (void)moveObjectAtIndexOfFavorite:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    
    NSMutableArray *favoriteDatas = [NSMutableArray arrayWithArray:[self sortWithFavoriteSortValueAscending]];
    LauncherData *fromFavoriteData = [favoriteDatas objectAtIndex:fromIndex];

    [favoriteDatas removeObject:fromFavoriteData];
    [favoriteDatas insertObject:fromFavoriteData atIndex:toIndex];

    [self updateFavoriteDataWith:favoriteDatas];
}

#pragma mark -
#pragma mark ===== Private Instance Method =====

/** お気に入りのソートバリューで降順にソートします */
- (NSArray *)sortWithFavoriteSortValueAscending
{
    NSArray *favoriteDatas = [self datasOfFavorite];

    NSArray *resultArry =
    [favoriteDatas sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        LauncherData * const data1 = (LauncherData *)obj1;
        LauncherData * const data2 = (LauncherData *)obj2;
        
        if (data1.favoriteSortValue > data2.favoriteSortValue) {
            
            return NSOrderedDescending;
            
        } else if (data2.favoriteSortValue > data1.favoriteSortValue) {
            
            return NSOrderedAscending;
            
        }
        
        return NSOrderedSame;
    }];
    
    return resultArry;
}

/** お気に入りのソートバリューを正しい値にする */
- (void)updateFavoriteData
{
    [self updateFavoriteDataWith:nil];
}

- (void)updateFavoriteDataWith:(NSArray *)datas;
{
    
    NSArray *favoriteDatas =
    (datas == nil) ? [self sortWithFavoriteSortValueAscending] : datas;

    NSMutableArray *wDatas = [NSMutableArray array];
    
    [favoriteDatas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        LauncherData *data = (LauncherData *)obj;
        data.favoriteSortValue = idx + 1;
        
        [TMFileManager saveLauncherData:[data dataDictionary]
                           withFileName:[data launcherDataFileName]];
        
        // ウィジェット用のデータ作成
        WidgetListData *wData = [WidgetListData createWithLauncherData:data];
        [wDatas addObject:[wData widgetDataDictionary]];
    }];
    
    [SSLShardFileManager saveWidgetDatas:wDatas];
    
}

/** お気に入りになっていないデータのお気に入りのソートバリューの値をリセットする */
- (void)resetFavoriteSortValueInNonFavorite
{
    [self.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        LauncherData *data = (LauncherData *)obj;
        
        if (YES == data.isFavorite) {
            return;
        }
        
        [data resetFavoriteSortValue];
        
        [TMFileManager saveLauncherData:[data dataDictionary]
                           withFileName:[data launcherDataFileName]];
    }];
}

/** お気に入りされているデータの配列を取得する */
- (NSArray *)datasOfFavorite
{
    static NSMutableArray *favoriteData = nil;
    
    static dispatch_once_t once;
    dispatch_once( &once, ^{
        favoriteData = [NSMutableArray array];
    });
    
    [favoriteData removeAllObjects];
    
    [self.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        LauncherData *data = (LauncherData *)obj;
        
        if (YES == data.isFavorite) {
            
            [favoriteData addObject:data];
        }
    }];
    
    return favoriteData;
}

/** WidgetListDataファイル(共有ファイル)の保存 */
- (void)updateWidgetListDatas
{
    NSArray * const favoriteDatas = [self sortWithFavoriteSortValueAscending];
    
    NSMutableArray *wDatas = [NSMutableArray array];
    
    [favoriteDatas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        // ウィジェット用のデータ作成
        WidgetListData *wData = [WidgetListData createWithLauncherData:(LauncherData *)obj];
        [wDatas addObject:[wData widgetDataDictionary]];
    }];
    
    [SSLShardFileManager saveWidgetDatas:wDatas];
}

@end


