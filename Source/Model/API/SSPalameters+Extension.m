//
//  SSPalameters+Extension.m
//  SSLauncher
//
//  Created by toomoo on 2014/10/03.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "SSPalameters+Extension.h"

@implementation SSPalameters (Extension)

+ (NSString *)stringFromSSFileNameFormatEx:(SSFileNameFormatEx)val
                          SSFileNameFormat:(SSFileNameFormat)orgVal
{
    NSString *valStr = @"";
    
    // 直接入力以外ではこの拡張列挙体は使用できない
    if (orgVal != SSFileNameFormatDirect) {
        return valStr;
    }
    
    switch (val) {
            
        case SSFileNameFormatExScanRuntime:
            valStr = NSLocalizedString(@"SSParam_FileNameFormat_ExeScanDirect", @"");
            break;
            
        default:
            valStr = NSLocalizedString(@"SSParam_FileNameFormat_ExeScanDirect", @"");
            break;
    }
    
    return valStr;
}

+ (NSString *)stringFromTMFileNamePrefix:(TMFileNamePrefix)val
{
    NSString *valStr = @"";
    
    switch (val) {
            
        case TMFileNamePrefixNone:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Prefix_None", @"");
            break;

        case TMFileNamePrefixyyyyMMdd:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Prefix_yyyyMMdd", @"");
            break;
            
        case TMFileNamePrefixyyyyMM:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Prefix_yyyyMM", @"");
            break;

        case TMFileNamePrefixyyyy:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Prefix_yyyy", @"");
            break;
        
        case TMFileNamePrefixMM:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Prefix_MM", @"");
            break;
            
        case TMFileNamePrefixMMdd:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Prefix_MMdd", @"");
            break;

        case TMFileNamePrefixDirectInput:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Prefix_DirectInput", @"");
            break;
            
        default:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Prefix_None", @"");
            break;
    }
    
    return valStr;
    
}

+ (NSString *)stringFromTMFileNameSuffix:(TMFileNameSuffix)val
{
    NSString *valStr = @"";
    
    switch (val) {
            
        case TMFileNameSuffixNone:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Suffix_None", @"");
            break;
            
        case TMFileNameSuffixyyyyMMdd:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Suffix_yyyyMMdd", @"");
            break;
            
        case TMFileNameSuffixyyyyMM:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Suffix_yyyyMM", @"");
            break;
            
        case TMFileNameSuffixyyyy:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Suffix_yyyy", @"");
            break;
            
        case TMFileNameSuffixMMdd:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Suffix_MMdd", @"");
            break;
            
        case TMFileNameSuffixMM:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Suffix_MM", @"");
            break;
            
        case TMFileNameSuffixDirectInput:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Suffix_DirectInput", @"");
            break;
            
        default:
            valStr = NSLocalizedString(@"SSParam_Ex_FileName_Suffix_None", @"");
            break;
    }
    
    return valStr;
    
}

+ (NSString *)stringFromTMDelimiterType:(TMDelimiterType)val
{
    
    NSString *valStr = @"";
    
    switch (val) {
            
        case TMDelimiterTypeUnderScore:
            valStr = NSLocalizedString(@"Delimiter_Type_UnderScore", @"");
            break;
            
        case TMDelimiterTypeHyphen:
            valStr = NSLocalizedString(@"Delimiter_Type_Hyphen", @"");
            break;
            
        case TMDelimiterTypeNone:
            valStr = NSLocalizedString(@"Delimiter_Type_None", @"");
            break;
            
        default:
            valStr = NSLocalizedString(@"Delimiter_Type_UnderScore", @"");
            break;
    }
    
    return valStr;
    
}

/** 連番タイプに合わせたフォーマットを返す */
+ (NSString *)stringSequentialNumberType:(TMSequentialNumberType)val
{
    NSString *valStr = @"";

    switch (val) {
            
        case TMSequentialNumberTypeNum:
            valStr = NSLocalizedString(@"SequentialNumber_Type_Num", @"");
            break;
            
        case TMSequentialNumberTypeNumParentheses:
            valStr = NSLocalizedString(@"SequentialNumber_Type_Num_Parentheses", @"");
            break;
            
        case TMSequentialNumberTypeNumBracket:
            valStr = NSLocalizedString(@"SequentialNumber_Type_Num_Bracket", @"");
            break;
            
        default:
            valStr = NSLocalizedString(@"SequentialNumber_Type_Num", @"");
            break;
    }
    
    return valStr;
}

@end
