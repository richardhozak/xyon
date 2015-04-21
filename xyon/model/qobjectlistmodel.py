from PyQt5.QtCore import *


class QObjectListModel(QAbstractListModel):

    def __init__(self, datain, parent=None, *args):
        QAbstractListModel.__init__(self, parent, *args)
        self.listdata = datain

    ObjectRole = Qt.UserRole + 1

    _roles = {ObjectRole: "object"}

    countChanged = pyqtSignal()

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
        self.listdata.append(item)
        self.endInsertRows()
        self.countChanged.emit()

    def extend(self, items):
        self.beginInsertRows(QModelIndex(), len(self.listdata), len(self.listdata) + len(items) - 1)
        for item in items:
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

    def indexOf(self, item):
        return self.listdata.index(item)

    def setObjectList(self, objects):
        old_count = self.count
        self.beginResetModel()
        self.listdata = objects
        self.endResetModel()
        self.dataChanged.emit(self.index(0), self.index(self.count))
        if self.count != old_count:
            self.countChanged.emit()

    def raw_data(self):
        return self.listdata

    def __iter__(self):
        return self.listdata.__iter__()
