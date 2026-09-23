package by.bsuir.laziness

import LazinessController
import LazinessModel
import MainView

fun main() {
    val appModel = LazinessModel()
    val appController = LazinessController(appModel)
    val mainFrame = MainView(appController, appModel)

    mainFrame.isVisible = true
}