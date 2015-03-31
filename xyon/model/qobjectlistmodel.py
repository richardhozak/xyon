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
        self.beginInsertRows(
            QModelIndex(), len(self.listdata), len(self.listdata))
        self.listdata.append(item)
        self.endInsertRows()
        self.countChanged.emit()

    def clear(self):
        if len(self.listdata) is 0:
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
