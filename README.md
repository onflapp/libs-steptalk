# StepTalk Scripting Framework

StepTalk is amazing scripting framework created by Stefan Urbanek. [orignal README](https://github.com/onflapp/libs-steptalk/blob/master/README)

I forked it to fix some issues that prevented it from working properly and I'm enhancing it 
further to make it work well as the main scripting environment for [GNUstep Desktop](https://github.com/onflapp/gs-desktop).

I would hope that one day my fork could be merged back into the original, in which point I would drop this one.

## GNUstep Desktop and scripting

The vision is to have *all application scriptable*.
An app can use scripts to enhance its own functionality by invoking external processes or other apps.

Good example is [ImageViewer.app](https://github.com/onflapp/gs-desktop/tree/main/Applications/ImageViewer/Scripts) which calls `Image Magick` to do image operations right within its users interface. 

#### Future direction:

- make it easier to create UI elements - e.g. input panel that asks for input
- expose scripts as menu items directly within the hosting app
- see if non-GNUstep apps could be made scriptable as well (e.g. WindowMaker) 
