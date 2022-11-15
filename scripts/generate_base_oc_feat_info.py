import json
from collections import Counter
from functools import partial, reduce
from itertools import chain
from pathlib import Path

import numpy
import pandas
import vigra

HAS_PLUGIN_MANAGER_IN_ENV = True

import ilastik

try:
    from ilastik.plugins import pluginManager
except ImportError:
    HAS_PLUGIN_MANAGER_IN_ENV = False


if not HAS_PLUGIN_MANAGER_IN_ENV:
    raise RuntimeError(
        "This script has to be run from a valid ilastik development environment."
    )


OUTPUT_PATH = Path(__file__).parent.parent / "_data" / "objectfeatures.json"


uint32empty = partial(numpy.empty, dtype="uint32")


float32empty = lambda x: numpy.empty(x).astype("float32")


def flatten_obj_feature_dict(inp, **kwargs):
    outp = []
    for plugin_name in inp:
        for feat_id, feat_data in inp[plugin_name].items():
            out_dict = dict(
                plugin_name=plugin_name, feature_id=feat_id, **feat_data, **kwargs
            )
            outp.append(out_dict)
    return outp


def main():
    featureDict = {}
    plugins = pluginManager.getPluginsOfCategory("ObjectFeatures")

    data_2d = vigra.taggedView(float32empty((10, 10)), "xy")
    data_2dc = vigra.taggedView(float32empty((10, 10, 3)), "xyc")
    labels_2d = vigra.taggedView(uint32empty((10, 10)), "xy")

    data_3d = vigra.taggedView(float32empty((10, 10, 10)), "xyz")
    data_3dc = vigra.taggedView(float32empty((10, 10, 10, 3)), "xyzc")
    labels_3d = vigra.taggedView(uint32empty((10, 10, 10)), "xyz")

    featureDicts = {}

    for spec, (data, labels) in {
        "2d": (data_2d, labels_2d),
        "2dc": (data_2dc, labels_2d),
        "3d": (data_3d, labels_3d),
        "3dc": (data_3dc, labels_3d),
    }.items():
        featureDict = {}
        for pluginInfo in plugins:
            if pluginInfo.name.lower().startswith("test"):
                continue
            availableFeatures = pluginInfo.plugin_object.availableFeatures(data, labels)
            if len(availableFeatures) > 0:
                featureDict[pluginInfo.name] = availableFeatures

        # Make sure no plugins use the same feature names.
        # (Currently, our feature export implementation doesn't support repeated column names.)
        all_feature_names = chain(
            *[list(plugin_dict.keys()) for plugin_dict in list(featureDict.values())]
        )
        feature_set = Counter(all_feature_names)
        # remove all elements with a count of 1
        feature_set = feature_set - Counter(feature_set.keys())
        if feature_set:
            offending_feature_names = feature_set.keys()
            raise ValueError(
                "Feature names used in multiple plugins. "
                f"Offending feature names: {list(offending_feature_names)}"
            )

        df = pandas.DataFrame(flatten_obj_feature_dict(featureDict))
        df[spec] = True
        featureDicts[spec] = df

    df_merged = reduce(
        lambda left, right: pandas.merge(
            left,
            right,
            on=[
                "displaytext",
                "plugin_name",
                "feature_id",
                "detailtext",
                "margin",
                "advanced",
                "tooltip",
                "group",
            ],
            how="outer",
        ),
        featureDicts.values(),
    )
    for col in ["2d", "2dc", "3d", "3dc"]:
        df_merged[col] = df_merged[col].fillna(False)
    df_merged["only_with_c"] = (~df_merged["2d"] & ~df_merged["3d"]) & (
        df_merged["2dc"] | df_merged["3dc"]
    )

    df_merged
    # df_merged.to_json(OUTPUT_PATH, indent=1, orient="records")

    js = {}
    for plugin_name in df_merged["plugin_name"].unique():
        js[plugin_name] = (
            df_merged[df_merged["plugin_name"] == plugin_name]
            .sort_values(
                by=["plugin_name", "feature_id", "group", "2d", "2dc", "3d", "3dc"]
            )
            .to_dict(orient="records")
        )

    OUTPUT_PATH.write_text(
        json.dumps(
            {"features": js, "ilastik.__version__": ilastik.__version__},
            indent=1,
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
