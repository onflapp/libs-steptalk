/**
    WebServicesConstants.m
 
    NOTE: Do not edit this file, it is automaticaly generated.
 
    Copyright (c) 2002 Free Software Foundation
 
    This file is part of the StepTalk project.
 
    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2 of the License, or (at your option) any later version.
 
    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.
 
    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 
 */

#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>
#import <Foundation/NSValue.h>

#import <WebServices/WebServices.h>


NSDictionary *STGetWebServicesConstants(void)
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    Class numberClass = [NSNumber class];
    IMP numberWithInt;
    IMP numberWithFloat;
    IMP setObject_forKey;

    SEL numberWithInt_sel = @selector(numberWithInt:);
    SEL numberWithFloat_sel = @selector(numberWithFloat:);
    SEL setObject_forKey_sel = @selector(setObject:forKey:);

    numberWithInt = [numberClass methodForSelector:numberWithInt_sel];
    numberWithFloat = [numberClass methodForSelector:numberWithFloat_sel];
    setObject_forKey = [dict methodForSelector:setObject_forKey_sel];

#define ADD_id_OBJECT(obj, name) \
            setObject_forKey(dict, setObject_forKey_sel, obj, name)

#define ADD_int_OBJECT(obj, name) \
            setObject_forKey(dict, setObject_forKey_sel, \
                            numberWithInt(numberClass, numberWithInt_sel, obj), \
                            name)

#define ADD_float_OBJECT(obj, name) \
            setObject_forKey(dict, setObject_forKey_sel, \
                            numberWithFloat(numberClass, numberWithInt_sel, obj), \
                            name)

    ADD_id_OBJECT(GWSErrorKey,@"GWSErrorKey");
    ADD_id_OBJECT(GWSFaultKey,@"GWSFaultKey");
    ADD_id_OBJECT(GWSMethodKey,@"GWSMethodKey");
    ADD_id_OBJECT(GWSOrderKey,@"GWSOrderKey");
    ADD_id_OBJECT(GWSParametersKey,@"GWSParametersKey");
    ADD_id_OBJECT(GWSRequestDataKey,@"GWSRequestDataKey");
    ADD_id_OBJECT(GWSResponseDataKey,@"GWSResponseDataKey");
    ADD_id_OBJECT(GWSSOAPBodyEncodingStyleKey,@"GWSSOAPBodyEncodingStyleKey");
    ADD_id_OBJECT(GWSSOAPBodyEncodingStyleDocument,@"GWSSOAPBodyEncodingStyleDocument");
    ADD_id_OBJECT(GWSSOAPBodyEncodingStyleRPC,@"GWSSOAPBodyEncodingStyleRPC");
    ADD_id_OBJECT(GWSSOAPBodyEncodingStyleWrapped,@"GWSSOAPBodyEncodingStyleWrapped");
    ADD_id_OBJECT(GWSSOAPUseKey,@"GWSSOAPUseKey");
    ADD_id_OBJECT(GWSSOAPUseEncoded,@"GWSSOAPUseEncoded");
    ADD_id_OBJECT(GWSSOAPUseLiteral,@"GWSSOAPUseLiteral");
    ADD_id_OBJECT(GWSSOAPMessageHeadersKey,@"GWSSOAPMessageHeadersKey");
    ADD_id_OBJECT(GWSSOAPNamespaceURIKey,@"GWSSOAPNamespaceURIKey");
    ADD_id_OBJECT(GWSSOAPNamespaceNameKey,@"GWSSOAPNamespaceNameKey");
    ADD_id_OBJECT(GWSSOAPArrayKey,@"GWSSOAPArrayKey");
    ADD_id_OBJECT(GWSSOAPTypeKey,@"GWSSOAPTypeKey");

    return dict;
}

/* -- End of file -- */