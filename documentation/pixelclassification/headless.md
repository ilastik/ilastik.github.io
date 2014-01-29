---
layout: documentation
title: Headless Operation
tagline:
category: "Documentation"
group: "workflow-documentation"
weight: 4
---
# Headless Mode Operation

The [Pixel Classification Workflow][] contains an interactive graphical user interface for training a classifier and refining your results.
However, once you're happy with your classifier, you may wish to apply it to other images without bothering with the graphical user interface at all.
For that use case, ilastik provides a command-line interface to the batch processing applet, a.k.a. "headless mode".

[Pixel Classification Workflow]: {{site.baseurl}}/documentation/pixelclassification/pixelclassification.html

Before you can use headless mode, create a project and train a classifier.  Then save your project and quit ilastik.

To start ilastik in "headless" mode, use the `--headless` command-line flag.

For example, on Linux:

    $ cd ilastik-Linux
    $ ./bin/ilastik_gui --headless

On Mac:

    $ ./ilastik.app/Contents/MacOS/ilastik --headless

And on Windows:

    $ cd "\Program Files\ilastik-1.0"
    $ .\ilastik.bat --headless

...but those commands will just start ilastik and immediately quit.
To do something useful, you'll need to load your project file, and provide some input data for batch predictions.
The following examples use linux shell syntax, but the options are the same for all platforms.

For example this example command will run your classifier over 2 additional images. 
(Here we assume your classifier was trained on 2D images.)

    $ ./bin/ilastik_gui --headless --project=MyProject.ilp my_next_image.png my_next_image2.png

## Using stack input

If you are dealing with 3D data in the form of an image sequence (e.g. a tiff stack), 
then use globstring syntax to tell ilastik which images to combine for each volume.

    $ ./bin/ilastik_gui --headless --project=MyProject.ilp "my_next_stack_*.png" "my_other_stack_*.png"

**Note:** The use of quotation marks in the above example is critical.  The `*` in each input argument must 
be provided to ilastik, NOT auto-expanded by the shell before ilastik sees the command!

## Output Options

By default, ilastik will export the results in hdf5 format, stored to the same directory as the input image.  
However, you can customize the output location and format with extra parameters. For example:

    $ ./bin/ilastik_gui --headless 
                        --project=MyProject.ilp
                        --output_format=tiff
                        --output_filename_format=/tmp/results/{nickname}_results.tiff
                        my_next_image.png my_next_image2.png

                        
Here's a quick summary of each command-line option provided by the headless interface.  
For the most part, these map directly to the corresponding controls in the [Data Export Settings Window][].
No matter what settings you use, the list of input files to process must come after all other items in 
the command (as shown in the example above).

[Data Export Settings Window]: {{site.baseurl}}/documentation/basics/export.html#settings

**Required settings:**

- `--headless` Invokes headless classification mode.
- `--project` The path to your project file, which you have already used to train a classifier.

**Optional settings:**

- `--output_format` The file format to store your results in. Some formats are less flexible than others and therefore cannot be combined with every option here. Choices are: `bmp`, `gif`, `hdr`, `jpeg`, `jpg`, `pbm`, `pgm`, `png`, `pnm`, `ppm`, `ras`, `tif`, `tiff`, `xv`, `bmp sequence`, `gif sequence`, `hdr sequence`, `jpeg sequence`, `jpg sequence`, `pbm sequence`, `pgm sequence`, `png sequence`, `pnm sequence`, `ppm sequence`, `ras sequence`, `tif sequence`, `tiff sequence`, `xv sequence`, `multipage tiff`, `multipage tiff sequence`, `hdf5`, `numpy`, `dvid`.
- `--output_filename_format` The path to the output file to write. A few "magic" placeholders can be used in these settings.  These are useful when you are exporting multiple datasets:
  - `{dataset_dir}` - the directory containing the original raw dataset corresponding these export results
  - `{nickname}` - the ilastik nickname of the raw dataset corresponding to these export results
  - `{roi}` - The region-of-interest as specified in the `--cutout_subregion` setting.
  - `{x_start}`, `{x_stop}`, `{y_start}`, `{y_stop}`, etc - Specific axis start/stop boundaries for the region-of-interest
  - `{slice_index}` - The index of each slice in an exported image sequence (required for all image sequence formats, not allowed with any other format).
- `--output_internal_path` (HDF5 only) Specifies the name of the HDF5 dataset to write to. (Default: `/exported_data`)
- `--cutout_subregion` Subregion to export (start,stop), e.g. `--cutout_subregion="[(0,0,0,0,0), (1,100,200,20,3)]"`
- `--export_dtype` The pixel type to convert your results to.  Choices are: `uint8`, `uint16`, `uint32`, `int8`, `int16`, `int32`, `float32`, `float64`.  Note that some formats don't support every pixel type.
- `--output_axis_order` Transpose the storage order of the results. For example, this affects the sliced dimension for stack outputs.
- `--pipeline_result_drange` Pipeline result data range (min,max) BEFORE normalization, e.g. `"(0.0, 1.0)"`
- `--export_drange` Exported data range (min,max) AFTER normalization, e.g. `"(0, 255)"`
