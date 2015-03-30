from PyQt5.QtCore import *


class QObjectListModel(QAbstractListModel):

    def __init__(self, datain, parent=None, *args):
        """ datain: a list where each item is a row
        """
        QAbstractListModel.__init__(self, parent, *args)
        self.listdata = datain

    def rowCount(self, parent=QModelIndex()):
        return len(self.listdata)

    def data(self, index, role):
        if index.isValid() and role == Qt.DisplayRole:
            return QVariant(self.listdata[index.row()])
        else:
            return QVariant()

    def append(self, item):
        self.beginInsertRows(QModelIndex(), len(self.listdata), len(self.listdata))
        self.listdata.append(item)
        self.endInsertRows()

    def clear(self):
        if len(self.listdata) is 0:
            return
        self.beginRemoveRows(QModelIndex(), 0, len(self.listdata) - 1)
        self.listdata = []
        self.endRemoveRows()
