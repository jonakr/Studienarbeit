import sys
import numpy as np
import pandas as pd
import h5py
from PyQt5.QtWidgets import QDialog, QApplication, QVBoxLayout, QComboBox

from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar
import matplotlib.pyplot as plt


class Window(QDialog):
    def __init__(self, parent=None):
        super(Window, self).__init__(parent)

        # load mat file
        self.file = h5py.File('11-48-21_hrv.mat','r')

        # a figure instance to plot on
        self.figure = plt.figure()

        # TODO: this combobox needs file headers later
        self.combobox = QComboBox()
        self.combobox.placeholderText = "Choose a value..."
        self.combobox.addItems(self.file.get('Res/HRV/TimeVar'))
        self.combobox.currentTextChanged.connect(self.plot)

        # this is the Canvas Widget that displays the `figure`
        # it takes the `figure` instance as a parameter to __init__
        self.canvas = FigureCanvas(self.figure)

        # this is the Navigation widget
        # it takes the Canvas widget and a parent
        self.toolbar = NavigationToolbar(self.canvas, self)

        # set the layout
        layout = QVBoxLayout()
        layout.addWidget(self.combobox)
        layout.addWidget(self.toolbar)
        layout.addWidget(self.canvas)
        self.setLayout(layout)

    def plot(self, header):

        data = np.array(self.file.get('Res/HRV/TimeVar/'+ header))[0]

        # instead of ax.hold(False)
        self.figure.clear()

        # create an axis
        ax = self.figure.add_subplot(111)

        # plot data
        ax.plot(data, '*-')

        # refresh canvas
        self.canvas.draw()

if __name__ == '__main__':
    app = QApplication(sys.argv)

    main = Window()
    main.show()

    sys.exit(app.exec_())
