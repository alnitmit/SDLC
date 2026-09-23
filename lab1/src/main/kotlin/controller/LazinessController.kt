import javax.swing.JFrame
import javax.swing.JOptionPane

class LazinessController(private val model: LazinessModel) {
    private var inputDialog: InputDialog? = null

    fun openInputDialog(parent: JFrame) {
        if (inputDialog == null || !inputDialog!!.isDisplayable) {
            inputDialog = InputDialog(parent, this)
        }
        inputDialog?.setValues(model.plannedTasks, model.completedTasks)
        inputDialog?.isVisible = true
    }

    fun processInput(plannedStr: String, doneStr: String) {
        try {
            val planned = plannedStr.trim().toInt()
            val done = doneStr.trim().toInt()

            model.setData(planned, done)

            inputDialog?.dispose()
        } catch (e: NumberFormatException) {
            showError("Неверный формат ввода! Разрешены только целые числа.")
        } catch (e: IllegalArgumentException) {
            showError(e.message ?: "Ошибка ввода данных")
        }
    }

    private fun showError(msg: String) {
        JOptionPane.showMessageDialog(null, msg, "Ошибка ввода данных", JOptionPane.ERROR_MESSAGE)
    }
}