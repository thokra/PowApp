//
//  main.m
//  Powder
//
//  Created by Thomas Siegfried Krampl on 4/18/11.
//  Copyright 2011 Sermo AS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
  return macruby_main("rb_main.rb", argc, argv);
}
