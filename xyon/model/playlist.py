import model.audioentry

from PyQt5.QtCore import *
from PyQt5.QtQml import QQmlEngine

class Playlist(QAbstractListModel):

    def __init__(self, datain, parent=None, *args):
        QAbstractListModel.__init__(self, parent, *args)
        self.listdata = datain
        self._currentIndex = -1

    ObjectRole = Qt.UserRole + 1

    _roles = {ObjectRole: "track"}

    countChanged = pyqtSignal()
    current_index_changed = pyqtSignal(name="currentIndexChanged")

    @pyqtProperty(int, notify=current_index_changed)
    def currentIndex(self):
        return self._currentIndex

    @currentIndex.setter
    def currentIndex(self, index):
        if self._currentIndex != index:
            self._currentIndex = index
            self.current_index_changed.emit()

    @pyqtProperty(int, notify=countChanged)
    def count(self):
        return len(self.listdata)

    def rowCount(self, parent=QModelIndex()):
        return len(self.listdata)

    def data(self, index, role):
        if index.isValid() and role == self.ObjectRole:
            return QVariant(self.listdata[index.row()])
        else:
            return QVariant()

    def append(self, item):
        self.beginInsertRows(QModelIndex(), len(self.listdata), len(self.listdata))
        QQmlEngine.setObjectOwnership(item, QQmlEngine.CppOwnership)
        self.listdata.append(item)
        self.endInsertRows()
        self.countChanged.emit()

    def extend(self, items):
        self.beginInsertRows(QModelIndex(), len(self.listdata), len(self.listdata) + len(items) - 1)
        for item in items:
            QQmlEngine.setObjectOwnership(item, QQmlEngine.CppOwnership)
            self.listdata.append(item)
        self.endInsertRows()
        self.countChanged.emit()

    def clear(self):
        if len(self.listdata) == 0:
            return
        self.beginRemoveRows(QModelIndex(), 0, len(self.listdata) - 1)
        self.listdata = []
        self.endRemoveRows()
        self.countChanged.emit()

    def roleNames(self):
        return self._roles

    def removeAt(self, index):
        self.beginRemoveRows(QModelIndex(), index, index)
        del self.listdata[index]
        self.endRemoveRows()
        self.countChanged.emit()

    def at(self, index):
        return self.listdata[index]

    @pyqtSlot(int, result=QObject)
    def get(self, index):
        return self.listdata[index]

    def indexOf(self, item):
        return self.listdata.index(item)

    def setObjectList(self, objects):
        old_count = self.count
        self.beginResetModel()
        for item in objects:
            QQmlEngine.setObjectOwnership(item, QQmlEngine.CppOwnership)
        self.listdata = objects
        self.endResetModel()
        self.dataChanged.emit(self.index(0), self.index(self.count))
        if self.count != old_count:
            self.countChanged.emit()

    def raw_data(self):
        return self.listdata

    def __iter__(self):
        return self.listdata.__iter__()

    @pyqtSlot(model.audioentry.AudioEntry)
    def add(self, entry):
        self.append(entry)
    
    @pyqtSlot(int)
    def remove_at(self, index):
        self.removeAt(index)

    @pyqtSlot(model.audioentry.AudioEntry)
    def remove(self, entry):
        index = self.indexOf(entry)
        if index != -1: # check whether indexOf returns -1 when it can't find the entry
            self.remove_at(index)
            if index == self.currentIndex:
                self.currentIndex = -1

    @pyqtSlot()
    def clear(self):
        self.clear()

    def load(self, data):
        entry_list = list(map(lambda e: model.audioentry.AudioEntry.deserialize(e, self), data))
        self.setObjectList(entry_list)

    def save(self):
        return list(map(model.audioentry.AudioEntry.serialize, self.listdata))

