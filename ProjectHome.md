### Notice ###

This project has moved to [Github](http://github.com/keithduncan/Amber) and is no longer maintained here

### Foreword ###

Amber is an Objective-C umbrella framework which extends the Cocoa API. It functions as my shared source repository, and consists of three frameworks; AmberFoundation which extends the Foundation framework, designed for use in Cocoa daemons; AmberKit which extends the AppKit framework, includes my custom UI controls, designed for use in GUI applications; and Core Networking.

There are a couple of additional frameworks which you are unlikely to use:
  * AmberKitAdditions.framework, a private framework which is not included in the Amber umbrella. It contains the AppKit extensions without the UI controls. It is a dependency of my custom UI controls when they aren't being built as part of AmberKit.
  * libAmberFoundation.a which contains most of the AmberFoundation code and is built for use in iPhone applications.

I use the frameworks in my own applications and custom UI controls (take a look at the NSBezierPath+Additions header, there's some handy drawing methods) and I'd encourage you to take a look through the headers and see if they could save you from implementing something I already have. I refactor any of my common code into the appropriate framework and include useful utilities that I find (and are appropriately attributed) so they are updated frequently. Feel free to use them in your own projects and contact me with any questions.

### Using the Framework ###

There are two ways to include Amber.framework in your own project.

  * The first (and potentially easier) way is to build the sources for Amber. Checkout a revision and make sure that both projects share a build directory, you will need to adjust your build settings if they don't. Drag Amber's Xcode project file into your project into the "Frameworks" group (it doesn't matter where you put it but the "Frameworks" group makes most sense). Once it's part of your project you need to make it a dependency to make sure it builds before your target. Get-info on your target and select the "General" tab, add Amber.framework to both the "Direct Dependency" and "Linked Framework" sections.

  * The second is to link against pre-built copies of the frameworks. You need to change the "Framework Search Paths" to include the directory where Amber.framework is found. This is probably going to be "$(SRCROOT)" - the quotes are important.

Finally, both methods require you to include the framework in your target's bundle. Amber and it's constituents are embedded frameworks and must be included in your build product. **Don't install them into a Library directory on the end user's system**

This requires an additional "Copy Files" build phase with the targets "Frameworks" directory as a destination.

### Considerations ###

Linking Amber implicitly links AmberFoundation and AmberKit, you only need to include Amber.framework which as an umbrella includes the others. As an embedded framework you must also include the appropriate runpath in your project build settings; this will typically be '@executable\_path/../Frameworks' for an Application or '@loader\_path/Frameworks' for a Framework.

The frameworks will work in both GC and non-GC environments and are compiled with -fobjc-gc. I've tested them using the GC runtime and found no issues. They are also fully  32/64 Bit compatible. The frameworks use the (AFAdditions) and (AKAdditions) category namespaces respectively, ensure this and the methods contained don't conflict with your own categories.

If you use either of the frameworks, let me know and I can link your page from here.

### Dependencies ###

  * Mac OS X Leopard 10.5
  * Objective-C 2.0
  * Xcode 3.2

Updated: 9/11/2009