import os
import subprocess


def join_path(location, filename):
    path = ""
    for loc in location:
        path += loc + os.sep
    return path + filename


def file_remove_last_line(filename):
    linefile = open(filename, "r+")
    lines = linefile.readlines()
    lines = lines[:-1]
    linefile.seek(0)
    linefile.truncate()
    linefile.writelines(lines)
    linefile.close()


def remove_file_if_exists(filename):
    if os.path.exists(filename):
        os.remove(filename)


def compile_resource(qrc_path):
    if not os.path.exists(qrc_path):
        raise ValueError(qrc_path + " does not exist.")

    res_path = os.path.dirname(qrc_path) + os.sep + "resources.py"

    print(qrc_path, "->", res_path)

    remove_file_if_exists(res_path)

    out = subprocess.call(["pyrcc5", qrc_path, "-o", res_path])

    if out is not 0:
        print("Failed to compile resource:", qrc_path)
        return

    file_remove_last_line(res_path)


def find_resources(rootpath):
    directories = []
    entries = os.listdir(rootpath)

    for entry in entries:
        entry_path = rootpath + os.sep + entry
        if os.path.isdir(entry_path):
            directories.extend(find_resources(entry_path))
        elif os.path.isfile(entry_path) and entry.endswith(".qrc"):
            directories.append(entry_path)

    return directories


class ResouceManager():

    def __init__(self, resman_path):
        remove_file_if_exists(resman_path)
        self.file = open(resman_path, "w")
        self.resources = []

    def add_resource(self, res_file):
        res_file = ".".join(os.path.dirname(res_file).split(os.sep)[1:])
        self.resources.append(res_file + ".resources")

    def close(self):
        for res in self.resources:
            self.file.write("import " + res + "\n")

        self.file.write("\n\ndef init_resources():\n")
        for res in self.resources:
            self.file.writelines("    " + res + ".qInitResources()\n")

        self.file.close()

if __name__ == "__main__":
    print("Compiling resources...")

    root_path = "xyon"
    resman_path = root_path + os.sep + "resource_manager.py"

    resman = ResouceManager(resman_path)

    for res_file in find_resources(root_path):
        compile_resource(res_file)
        resman.add_resource(res_file)

    resman.close()

    print("Resources compiled.")
