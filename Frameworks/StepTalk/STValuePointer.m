/**
    STValuePointer.m
 
    Copyright (c) 2002 Free Software Foundation
 
    This file is part of the StepTalk project.
 
 */

#import "STValuePointer.h"
#import <StepTalk/STScript.h>

@implementation STValuePointer

- (id) initWithObjCType:(const char*) objCType
{
    self = [super init];
    _objCType        = objCType;
    _objCType_range  = @encode(NSRange);
    _objCType_size   = @encode(NSSize);
    _objCType_rect   = @encode(NSRect);
    _objCType_point  = @encode(NSPoint);
    _objCType_object = @encode(NSObject);

    _range    = NSMakeRange(0, 0);
    _size     = NSMakeSize(0, 0);
    _rect     = NSMakeRect(0, 0, 0, 0);
    _point    = NSMakePoint(0, 0);
    return self;
}

- (void*) pointerValue
{
  if (_objCType == _objCType_range)
  {
    return &_range;
  }
  else if (_objCType == _objCType_size)
  {
    return &_size;
  }
  else if (_objCType == _objCType_rect)
  {
    return &_rect;
  }
  else if (_objCType == _objCType_point)
  {
    return &_point;
  }
  else if (_objCType == _objCType_object)
  {
    return &_object;
  }
  else
  {
      [NSException raise:NSInternalInconsistencyException
                        format:@"Unknown type %s", _objCType];
      return NULL;
  }
}

- (NSRange) rangeValue 
{
    return _range;
}

- (NSSize) sizeValue 
{
    return _size;
}

- (NSRect) rectValue 
{
    return _rect;
}

- (NSPoint) pointValue 
{
    return _point;
}

- (NSObject*) objectValue 
{
    return _object;
}
@end
