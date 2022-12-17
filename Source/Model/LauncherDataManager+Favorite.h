//
//  LauncherDataManager+Favorite.h
//  SSLauncher
//
//  Created by toomoo on 2015/01/17.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import "LauncherDataManager.h"

@interface LauncherDataManager (Favorite)

- (LauncherData *)objectAtIndexOfFavorite:(NSUInteger)index;

- (NSUInteger)countOfFavorite;

- (void)moveObjectAtIndexOfFavorite:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

/** お気に入りのソートバリューを正しい値にする */
- (void)updateFavoriteData;

/** お気に入りになっていないデータのお気に入りのソートバリューの値をリセットする */
- (void)resetFavoriteSortValueInNonFavorite;

/** ウィジェットとの共有ファイルを更新する */
- (void)updateWidgetListDatas;

@end
