import sys
import os
import shutil
import platform
from cx_Freeze import main


def copy_to_release(path, src):
    shutil.copytree(os.path.join(path, src), os.path.join("release", src))

if __name__ == "__main__":
    if os.path.isdir("release"):
        shutil.rmtree("release")

    if os.path.exists("xyon.zip"):
        os.remove("xyon.zip")

    print(sys.argv)

    icon_extensions = {
        "Windows": ".ico",
        "Darwin": ".icns",
        "Linux": ".png"
    }

    sys.argv = [sys.argv[0]]
    system = platform.system()
    target_name = "xyon" + (".exe" if system == "Windows" else "")
    sys.argv.extend(["--target-name=" + target_name,
                     "--target-dir=release",
                     "--icon=xyon" + os.sep + "icon" + icon_extensions[system],
                     "xyon" + os.sep + "main.py"])

    main()

    print("copying necessary runtime files to output from", end=" ")

    package_path = None

    for path in sys.path:
        if path.endswith("site-packages"):
            package_path = path
            break

    print("package_path", package_path)

    pyqt_path = os.path.join(package_path, "PyQt5")
    plugin_path = os.path.join(pyqt_path, "plugins")
    qml_path = os.path.join(pyqt_path, "qml")

    copy_to_release(plugin_path, "mediaservice")
    copy_to_release(qml_path, "QtGraphicalEffects")
    copy_to_release(qml_path, "QtMultimedia")
    copy_to_release(qml_path, "QtQml")
    copy_to_release(qml_path, "QtQuick")
    copy_to_release(qml_path, "QtQuick.2")

    shutil.make_archive(base_name="xyon", format="zip", root_dir="release")
    print("done")