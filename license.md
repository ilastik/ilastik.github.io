---
layout: default
title: ilastik License
category: "About"
---

The ilastik software suite is based on three Python packages licensed as follows:

* [ilastik](http://github.com/ilastik/ilastik): [GNU General Public License version 2 or later with exception to allow non-GPL extensions](#ilastik-license)
* [lazyflow](http://github.com/ilastik/lazyflow): [GNU Lesser Public License 2.1 or later](https://www.gnu.org/licenses/lgpl-2.1.html)
* [volumina](http://github.com/ilastik/volumina): [GNU Lesser Public License 2.1 or later](https://www.gnu.org/licenses/lgpl-2.1.html)

All packages are

`Copyright © 2011-2018, the ilastik developers <team@ilastik.org>`

Feel free to contact [the ilastik team](mailto:team@ilastik.org) for questions regarding licensing.

## ilastik license

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
[GNU General Public License](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html) for more details.


Extending ilastik with other modules is making a combined work based
on ilastik. Thus, the terms and conditions of the GNU General Public
License cover the whole combination.

In addition, as a special exception, the copyright holders of ilastik
give you permission to combine ilastik with applets, workflows and
plugins which are not covered under the GNU General Public License.
These are considered independent modules provided that

<ol type="i">
<li> plugins are subclasses of IPlugin and communicate with ilastik
  through the plugin interface defined in the documentation
  </li>
<li> applets are subclasses of Applet and AppletGuiInteface classes
  and communicate with ilastik through the Applet API defined in
  the documentation</li>
<li>workflows are subclasses of Workflow and communicate with
  ilastik through the Workflow API defined in the documentation.
  Workflows can make use of standard applets provided in ilastik.</li>
</ol>

You may copy and distribute such a combined work following the
terms of the GNU GPL for the ilastik part, and terms of your
choice for independent modules as specified in items (i), (ii)
and (iii) provided that you also meet, for each of these
modules, the terms and conditions of the license of that module.

A modified version of ilastik that involves changes to the
interface of the ilastik applet, workflow or plugin interface must
be distributed under the GNU GPL without this exception. Modified
versions of ilastik that preserve the original ilastik applet,
workflow or plugin interfaces must be distributed under the GNU
GPL; in which case the license may, but need not, carry forward
this exception.
