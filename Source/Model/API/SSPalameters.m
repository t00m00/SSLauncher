//
//  SSPalameters.m
//  SSLauncher
//
//  Created by toomoo on 2014/08/31.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "SSPalameters.h"

@implementation SSPalameters

+ (NSString *)stringFromSSFileFormat:(SSFileFormat)val
{
    NSString *valStr = @"";
    
    switch (val) {
        case SSFileFormatPDF:
            valStr = NSLocalizedString(@"SSParam_FileFormat_PDF", @"");
            break;

        case SSFileFormatJpeg:
            valStr = NSLocalizedString(@"SSParam_FileFormat_JPEG", @"");
            break;
            
        default:
            valStr = NSLocalizedString(@"SSParam_FileFormat_PDF", @"");
            break;
    }
    
    return valStr;
}

+ (NSString *)pathExtensionFromSSFileFormat:(SSFileFormat)val
{
    NSString *valStr = @"";
    
    switch (val) {
        case SSFileFormatPDF:
            valStr = @"pdf";
            break;
            
        case SSFileFormatJpeg:
            valStr = @"jpeg";
            break;
            
        default:
            valStr = @"pdf";
            break;
    }
    
    return valStr;
}

+ (NSString *)stringFromSSScanningSide:(SSScanningSide)val
{
    NSString *valStr = @"";
    
    switch (val) {
        case SSScanningSideBoth:
            valStr = NSLocalizedString(@"SSParam_ScanSide_Both", @"");
            break;

        case SSScanningSideSingle:
            valStr = NSLocalizedString(@"SSParam_ScanSide_Single", @"");
            break;
            
        default:
            valStr = NSLocalizedString(@"SSParam_ScanSide_Both", @"");
            break;
    }
    
    return valStr;
}

+ (NSString *)stringFromSSColorMode:(SSColorMode)val
{
    NSString *valStr = @"";
    
    switch (val) {
        case SSColorModeAuto:
            valStr = NSLocalizedString(@"SSParam_ColorMode_Auto", @"");
            break;
            
        case SSColorModeColor:
            valStr = NSLocalizedString(@"SSParam_ColorMode_Color", @"");
            break;
            
        case SSColorModeMono:
            valStr = NSLocalizedString(@"SSParam_ColorMode_Mono", @"");
            break;
            
        case SSColorModeGray:
            valStr = NSLocalizedString(@"SSParam_ColorMode_Gray", @"");
            break;
            
        default:
            valStr = NSLocalizedString(@"SSParam_ColorMode_Auto", @"");
            break;
    }
    
    return valStr;
}

+ (NSString *)stringFromSSMonoConcentration:(SSMonoConcentration)val
{
    NSString *valStr = @"";
    
    switch (val) {
        case SSMonoConcentrationLvMinus5:
            valStr = NSLocalizedString(@"SSParam_MonoCctn_m5", @"");
            break;

        case SSMonoConcentrationLvMinus4:
            valStr = NSLocalizedString(@"SSParam_MonoCctn_m4", @"");
            break;

        case SSMonoConcentrationLvMinus3:
            valStr = NSLocalizedString(@"SSParam_MonoCctn_m3", @"");
            break;

        case SSMonoConcentrationLvMinus2:
            valStr = NSLocalizedString(@"SSParam_MonoCctn_m2", @"");
            break;

        case SSMonoConcentrationLvMinus1:
            valStr = NSLocalizedString(@"SSParam_MonoCctn_m1", @"");
            break;
            
        case SSMonoConcentrationLv0:
            valStr = NSLocalizedString(@"SSParam_MonoCctn_0", @"");
            break;

        case SSMonoConcentrationLv1:
            valStr = NSLocalizedString(@"SSParam_MonoCctn_1", @"");
            break;

        case SSMonoConcentrationLv2:
            valStr = NSLocalizedString(@"SSParam_MonoCctn_2", @"");
            break;

        case SSMonoConcentrationLv3:
            valStr = NSLocalizedString(@"SSParam_MonoCctn_3", @"");
            break;

        case SSMonoConcentrationLv4:
            valStr = NSLocalizedString(@"SSParam_MonoCctn_4", @"");
            break;

        case SSMonoConcentrationLv5:
            valStr = NSLocalizedString(@"SSParam_MonoCctn_5", @"");
            break;
            
        default:
            valStr = NSLocalizedString(@"SSParam_MonoCctn_0", @"");
            break;
    }
    
    return valStr;
}

+ (NSString *)stringFromSSScanMode:(SSScanMode)val
{
    NSString *valStr = @"";
    
    switch (val) {
        case SSScanModeNormal:
            valStr = NSLocalizedString(@"SSParam_ScanMode_Normal", @"");
            break;
            
        case SSScanModeFine:
            valStr = NSLocalizedString(@"SSParam_ScanMode_Fine", @"");
            break;
            
        case SSScanModeSuperFine:
            valStr = NSLocalizedString(@"SSParam_ScanMode_SuperFine", @"");
            break;
            
        case SSScanModeAuto:
            valStr = NSLocalizedString(@"SSParam_ScanMode_Auto", @"");
            break;
            
        default:
            valStr = NSLocalizedString(@"SSParam_ScanMode_Auto", @"");
            break;
    }
    
    return valStr;
}

+ (NSString *)stringFromSSFileNameFormat:(SSFileNameFormat)val
{
    NSString *valStr = @"";
    
    switch (val) {
        case SSFileNameFormatJP:
            valStr = NSLocalizedString(@"SSParam_FileNameFormat_JP", @"");
            break;
            
        case SSFileNameFormatNoSeparator:
            valStr = NSLocalizedString(@"SSParam_FileNameFormat_NoSep", @"");
            break;
            
        case SSFileNameFormatDirect:
            valStr = NSLocalizedString(@"SSParam_FileNameFormat_Direct", @"");
            break;
            
        case SSFileNameFormatSeparatorHyphen:
            valStr = NSLocalizedString(@"SSParam_FileNameFormat_SepHyphen", @"");
            break;
            
        default:
            valStr = NSLocalizedString(@"SSParam_FileNameFormat_NoSep", @"");
            break;
    }
    
    return valStr;
}

+ (NSString *)stringFromSSPaperSize:(SSPaperSize)val
{
    NSString *valStr = @"";
    
    switch (val) {
        case SSPaperSizeAuto:
            valStr = NSLocalizedString(@"SSParam_PaperSize_Auto", @"");
            break;
        
        case SSPaperSizeA4:
            valStr = NSLocalizedString(@"SSParam_PaperSize_A4", @"");
            break;
            
        case SSPaperSizeA5:
            valStr = NSLocalizedString(@"SSParam_PaperSize_A5", @"");
            break;
            
        case SSPaperSizeA6:
            valStr = NSLocalizedString(@"SSParam_PaperSize_A6", @"");
            break;
            
        case SSPaperSizeB5:
            valStr = NSLocalizedString(@"SSParam_PaperSize_B5", @"");
            break;
            
        case SSPaperSizeB6:
            valStr = NSLocalizedString(@"SSParam_PaperSize_B6", @"");
            break;
            
        case SSPaperSizePostCard:
            valStr = NSLocalizedString(@"SSParam_PaperSize_PostCard", @"");
            break;
            
        case SSPaperSizeBusinessCard:
            valStr = NSLocalizedString(@"SSParam_PaperSize_BusinessCard", @"");
            break;
            
        case SSPaperSizeLetter:
            valStr = NSLocalizedString(@"SSParam_PaperSize_Letter", @"");
            break;
            
        case SSPaperSizeLegal:
            valStr = NSLocalizedString(@"SSParam_PaperSize_Legal", @"");
            break;
            
        default:
            valStr = NSLocalizedString(@"SSParam_PaperSize_Auto", @"");
            break;
    }
    
    return valStr;
}

+ (NSString *)stringFromSSCompression:(SSCompression)val
{
    NSString *valStr = @"";
    
    switch (val) {
        case SSCompressionLvMinus2:
            valStr = NSLocalizedString(@"SSParam_Compression_M2", @"");
            break;
        
        case SSCompressionLvMinus1:
            valStr = NSLocalizedString(@"SSParam_Compression_M1", @"");
            break;
            
        case SSCompressionLv0:
            valStr = NSLocalizedString(@"SSParam_Compression_0", @"");
            break;
            
        case SSCompressionLv1:
            valStr = NSLocalizedString(@"SSParam_Compression_1", @"");
            break;
            
        case SSCompressionLv2:
            valStr = NSLocalizedString(@"SSParam_Compression_2", @"");
            break;
            
        default:
            valStr = NSLocalizedString(@"SSParam_Compression_0", @"");
            break;
    }
    
    return valStr;
}

@end
