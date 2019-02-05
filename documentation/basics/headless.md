---
layout: documentation
title: Headless Operation
tagline:
category: "Documentation"
group: "basic-documentation"
weight: 6
---
# Headless Mode Operation - Using ilastik as a command line tool

## General

ilastik has an interactive graphical user interface for training a classifier and refining your results. Once you're happy with your classifier, you may wish to apply it to several other images using the [Batch Processing Applet]({{site.baseurl}}/documentation/basics/batch). Still, if you wish to run ilastik from inside your automation scripts or in environments with no graphical capabilities (e.g.: HPC clusters), then you can use the "headless" mode, which will allow you to run ilastik as a command line tool.

Except for the Carving Workflow, all workflows are able to run in headless mode.

In order to run ilastik in headless mode, you will need to use the graphical user interface to create a project and train a classifier by manually drawing annotations as usual (see, e.g. [Pixel Classification Workflow]({{site.baseurl}}/documentation/pixelclassification/pixelclassification.html) or [Object Classification Workflow] for instructions on how to train your classifier). Once you're done with the training, save your project and quit ilastik.

When running ilastik in headless mode, you must specify at least:

- The `--headless` flag, to trigger headless operation;
- Your pre-trained ilastik `.ilp` project file, via the `--project` argument (e.g. `--project=MyPixelClassProj.ilp`);
- One or more files to be processed as a batch. Those should always be given as the last arguments to the command line.

For example, this command will run your classifier over 2 additional images (here we assume your classifier was trained on 2D images):

Linux:

    $ cd ilastik-1.3.2-Linux/
    $ ./run_ilastik.sh --headless --project=MyProject.ilp my_next_image1.png my_next_image2.png

Mac:

    $ ./ilastik-1.3.2-OSX.app/Contents/ilastik-release/run_ilastik.sh  --headless --project=MyProject.ilp my_next_image1.png my_next_image2.png

Windows:

    $ cd "\Program Files\ilastik-1.3.2"
    $ .\ilastik.bat --headless --project=MyProject.ilp my_next_image1.png my_next_image2.png

**Note:** the following examples use linux shell syntax, but the options are the same for all platforms.

### Important Notes:

- Except for options passed with the `--export_source` argument (see below), don't specify any values with space-characters in them, even if inside quotes (e.g. `"my file name.h5"`, or `"(10, 20)"`). Due to a [bug in cpython](https://bugs.python.org/issue22433) those might be misinterpreted.
- For paths to hdf5 datasests (either input or output), ilastik uses the same conventions as the generic [h5ls](https://support.hdfgroup.org/HDF5/Tutor/cmdtoolview.html#h5ls) utility. That is, the hdf5 dataset name should be appended to the file path: `/path/to/my_file.h5/internal/path/to/dataset`.
- In the current "headless" implementation of object classification, the entire image is loaded into RAM in one go, and then object classification is run on it.  Therefore, there is a limit to how large your input image can be.
- ilastik's command line options use underlines rather than dashes to separate words (e.g.: `--cutout_subregion` and not `--cutout-subregion`). If you mix them up, you might get strange errors. See [Known Issues](#known-issues) for more info.

### Using stack input

If you are dealing with 3D data in the form of an image sequence (e.g. a tiff stack), 
then use globstring syntax to tell ilastik which images to combine for each volume.

    $ ls ~/mydata/
    my_stack_1.png        my_stack_2.png        my_stack_3.png        my_stack_4.png
    my_other_stack_1.png  my_other_stack_2.png  my_other_stack_3.png  my_other_stack_4.png
    
    $ ./run_ilastik.sh --headless \
                       --project=MyProject.ilp \
                       "~/mydata/my_stack_*.png" "~/mydata/my_other_stack_*.png"

**Note:** The use of quotation marks in the above example is critical.  The `*` in each input argument must 
be provided to ilastik, NOT auto-expanded by the shell before ilastik sees the command!

### Output Options

By default, ilastik will export the results in hdf5 format, stored to the same directory as the input image.  
However, you can customize the output location and format with extra parameters. For example:

    $ ./run_ilastik.sh --headless \
                       --project=MyProject.ilp \
                       --output_format=tiff \
                       --output_filename_format=/tmp/results/{nickname}_results.tiff \
                       my_next_image1.png my_next_image2.png

Here's a quick summary of each command-line option provided by the headless interface.
For the most part, these map directly to the corresponding controls in the [Data Export Settings Window][].
No matter what settings you use, the list of input files to process must come after all other items in 
the command (as shown in the example above).

[Data Export Settings Window]: {{site.baseurl}}/documentation/basics/export.html#settings

**Required settings:**

- `--headless` Invokes headless classification mode.
- `--project` The path to your project file, which you have already used to train a classifier.

**Optional settings:**

- `--export_source` The data to export, which in general should be an option from the 'Source' dropdown in the [Data Export Applet][] for your workflow. See the individual section of this page for the workflow you're interested in.
- `--output_format` The file format to store your results in. Some formats are less flexible than others and therefore cannot be combined with every option here. Choices are: `bmp`, `gif`, `hdr`, `jpeg`, `jpg`, `pbm`, `pgm`, `png`, `pnm`, `ppm`, `ras`, `tif`, `tiff`, `xv`, `bmp sequence`, `gif sequence`, `hdr sequence`, `jpeg sequence`, `jpg sequence`, `pbm sequence`, `pgm sequence`, `png sequence`, `pnm sequence`, `ppm sequence`, `ras sequence`, `tif sequence`, `tiff sequence`, `xv sequence`, `multipage tiff`, `multipage tiff sequence`, `hdf5`, `compressed hdf5`, `numpy`, `dvid`.
- `--output_filename_format` The path to the output file to write. A few "magic" placeholders can be used in these settings.  These are useful when you are exporting multiple datasets:
  - `{dataset_dir}` - the directory containing the original raw dataset corresponding these export results
  - `{nickname}` - expands to the raw input file basename. E.g.: if your input file is called myImage.png, `{nickname}` will expand to `myImage`
  - `{roi}` - The region-of-interest as specified in the `--cutout_subregion` setting.
  - `{x_start}`, `{x_stop}`, `{y_start}`, `{y_stop}`, etc - Specific axis start/stop boundaries for the region-of-interest
  - `{slice_index}` - The index of each slice in an exported image sequence (required for all image sequence formats, not allowed with any other format).
- `--output_internal_path` (HDF5 only) Specifies the name of the HDF5 dataset to write to. (Default: `/exported_data`)
- `--cutout_subregion` Subregion from the original to imput to operate on. The expected format is `[(axis_1_start,axis_2_start,...,axis_n_start),(axis_1_stop,axis_2_stop,...,axis_n_stop)]`. The order of the axis is the same order as in your input image. The start values are inclusive and the stop values are exclusive. You can replace any value with `None` to have it be interpreted as `0` in the start values or the maximum value in that axis for the stop values. If you specify a region that exceeds the shape of your input image, ilastik will crop your selection so that it fits the input shape.
    E.g.: If your image is a png file with axis x y c, then you could run a headless prediction on a 50x50 square starting from 10x10 and containing all channels by specifying `--cutout_subregion="[(10,10,None),(60,60,None)]"`.
- `--export_dtype` The pixel type to convert your results to.  Choices are: `uint8`, `uint16`, `uint32`, `int8`, `int16`, `int32`, `float32`, `float64`.  Note that some formats don't support every pixel type.
- `--output_axis_order` Transpose the storage order of the results. For example, this affects the sliced dimension for stack outputs.
- `--pipeline_result_drange` Pipeline result data range (min,max) BEFORE normalization, e.g. `"(0.0,1.0)"`
- `--export_drange` Exported data range (min,max) AFTER normalization, e.g. `"(0,255)"`

[Data Export Applet]: {{site.baseurl}}/documentation/basics/export.html#data-export-applet-ss

## Headless Mode for Pixel Classification

When running the Pixel Classification Workflow in headless mode, the available options for the `--export_source` flag are:

- `"Probabilities"`, which exports a multi-channel image where pixel values represent the probability that that pixel belongs to the class represented by that channel;
- `"Simple Segmentation"`, which produces a single-channel image where the (integer) pixel values indicate the class to which a pixel belongs. For this image, every pixel with the same value should belong to the same class of pixels;
- `Uncertainty`, which produces an image where pixel intensity is proportional to the uncertainty found when trying to classify that pixel;
- `Features`, which outputs a multi-channel image where each channel represents one of the computed pixel features;
- `Labels`, which outputs an image representing the users' manually created annotations.

## Headless Mode for Autocontext Workflow

The [Autocontext]({{site.baseurl}}/documentation/autocontext/autocontext) workflow is essentially two runs of pixel classification, with the latter one using the output of the first one as an additional input. When running the Autocontext Workflow in headless mode, the available options for the `--export_source` are analogous to those of the simple Pixel Classification Workflow, but you can export the results of any of the two pixel classification stages involved in this workflow. Here's the full list of options:

- `"Probabilities Stage 1"`;
- `"Probabilities Stage 2"`;
- `"Simple Segmentation Stage 1"`;
- `"Simple Segmentation Stage 2"`;
- `"Uncertainty Stage 1"`;
- `"Uncertainty Stage 2"`;
- `"Features Stage 1"`;
- `"Features Stage 2"`;
- `"Labels Stage 1"`;
- `"Labels Stage 2"`;
- `"Propabilities All Stages"`: equivalent to exporting both `"Probabilities Stage 1"` and `"Probabilities Stage 2"`;
- `"Input Stage 1"`: output your raw input image that was fed into the first stage of the workflow;
- `"Input Stage 2"`, wich is the input received by the second Pixel Classification stage in the workflow

## Headless Mode for Object Classification

When running the Object Classification Workflow in headless mode, the available options for the `--export_source` flag are:
- `"Object Predictions"` (default when nothing is specified), which exports a label image of the object class predictions;
- `"Object Probabilities"`, which exports a multi-channel image volume of object prediction probabilities instead of a label image (one channel for each prediction class);
- `"Blockwise Object Predictions"` or `"Blockwise Object Probabilities"`, which is analogous to `"Object Predictions"` and `"Object Probabilities"` respectively, but the image will be processed in independent blocks, which is useful when your image won't fit in RAM. Note that the values for the block size and halo cannot be configured via command line parameters and must be set in yout `.ilp` project file via the graphical user interface. See [Blockwise Object Classification Applet]({{site.baseurl}}/documentation/objects/objects.html#preparing-for-large-scale-prediction---blockwise-object-classification-applet).
- `"Pixel Probabilities"`, which exports the pixel prediction images of the pixel classification part of that workflow. Only valid if you specified an `.ilp` `--project` that was created with the  "Pixel Classification + Object Classification" workflow.


[Object Classification Workflow]: {{site.baseurl}}/documentation/objects/objects.html

Depending on which variant of the [Object Classification Workflow] you used to create your `.ilp` project file, you may need to provide more than one input image for each volume of data you want to process (e.g. "Raw Data" and "Segmentation Image" for , or "Raw Data" and "Prediction Maps"). These input images correspond to the tabs in the `Input Data` applet of the Object Classification Workflow and must be provided on the command-line.  To specify which is which, prefix the list of input files with either `--raw_data`, `--segmentation_image`, or `--prediction_maps` accordingly. Here's an example of invoking ilastik with an Object Classification Workflow that takes a Segmentation Image as input:

    $ ./run_ilastik.sh --headless \
                       --project=MyObjClassFromPredictMap.ilp \
                       --table_filename=/tmp/exported_object_features.csv \
                       --export_source="Object Predictions" \
                       --raw_data "my_grayscale_stack_1/*.png" \
                       --segmentation_image my_unclassified_objects_1.h5/binary_segmentation_volume

If you provide a path for the `--table_filename` output, ilastik will export a `.csv` file of the computed object features that were used during classification, indexed by object id.

So, the example command above produces 3 files: 

- a prediction image (a label image), 
- a floating-point "probability image" (with N channels -- one for each class), and 
- a .csv file containing a row for each object and columns for each of the features your project uses.  This file also contains the probability value for each object.

If you are processing more than one volume in a single command, provide all inputs of a given type in sequence:

    $ ./run_ilastik.sh --headless \
    --project=MyObjClassFromSegmentation.ilp \
    --raw_data "my_grayscale_stack_1/*.png" "my_grayscale_stack_2/*.png" "my_grayscale_stack_3/*.png" \
    --segmentation_image my_unclassified_objects_1.h5/binary_segmentation_volume my_unclassified_objects_2.h5/binary_segmentation_volume my_unclassified_objects_3.h5/binary_segmentation_volume

## Headless Mode for Counting Workflow

When running the Object Classification Workflow in headless mode, the only available option for the `--export_source` is `Probabilities`.

Additional arguments:
- `--csv-export-file` (optional): File path to which a .csv with total object counts should be exported.

## Controlling CPU and RAM resources

By default, ilastik will use all available CPU cores (as detected by Python's "multiprocessing" module), including "virtual" cores if your CPU supports hyperthreading (like most modern Intel processors).

If you want to explicitly specify the number of parallel threads ilastik should use, you can do so via a special environment variable recognized by ilastik:

    LAZYFLOW_THREADS=4 run_ilastik.sh --headless ...
    
There's an additional environment variable for specifying how much RAM to use during headless execution:

    LAZYFLOW_THREADS=4 LAZYFLOW_TOTAL_RAM_MB=4000 run_ilastik.sh --headless ...
    
The RAM limit is not perfectly respected in all cases, so you may want to leave some buffer if your RAM budget is strict.

## Running your own Python scripts

For developers and power-users, you can run your own ilastik-dependent python scripts using the interpreter shipped within the ilastik install tree.  The interpreter is located in the `bin` directory:

    # Linux
    $ ./ilastik-1.3.2-Linux/bin/python -c "import ilastik; print ilastik.__version__"
    1.3.2
    
    # Mac
    $ ./ilastik-1.3.2-OSX.app/Contents/ilastik-release/bin/python -c "import ilastik; print ilastik.__version__"
    1.3.2

## Known Issues

ilastik's headless mode will sometimes throw exceptions and output a stack trace instead of letting you known why your command line arguments are wrong. Though those issues are being worked on, here are some hints and workarounds you can use to get by:

* 'RuntimeError: Could not find one or more input files.  See logged errors.'

    If you're sure that all files passed as arguments to ilastik actually exist, then ilastik might be misinterpreting some arguments as files to be processed rather than command line flags. For example, if you use `--output-format png` (with a dash between 'output' and 'format') instead of `--output_format png` (with an underline), then the words `--output-format` and `png` might be interpreted as files to be processed by the workflow, and those probably won't be found in your machine, which will trigger the error.
