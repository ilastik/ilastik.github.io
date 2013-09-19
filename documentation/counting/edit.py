import glob
import os
filenames=glob.glob("fig/*.png")
for filename in filenames:
    f2,ext=os.path.splitext(filename)
    f2=f2+".jpg"
    command="convert %s %s"%(filename,f2)
    print command
    os.system(command)
