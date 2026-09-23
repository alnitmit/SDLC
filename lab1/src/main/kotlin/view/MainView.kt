import java.awt.BorderLayout
import java.awt.Color
import java.awt.Font
import java.awt.GridLayout
import javax.swing.*

class MainView(
    private val controller: LazinessController,
    private val model: LazinessModel
) : JFrame(), LazinessModel.ModelListener {

    private val lblStats = JLabel("Параметры пока не заданы")
    private val lblResult = JLabel("Ваш коэффициент лени: -")
    private val lblPhrase = JLabel("")

    init {
        model.addListener(this)
        initView()
    }

    private fun initView() {
        title = "Калькулятор Лени (MVC)"
        setSize(420, 260)
        defaultCloseOperation = EXIT_ON_CLOSE
        setLocationRelativeTo(null)
        layout = BorderLayout(15, 15)

        val panelInfo = JPanel(GridLayout(3, 1, 10, 10)).apply {
            border = BorderFactory.createEmptyBorder(25, 25, 20, 25)
        }

        lblResult.font = Font("Segoe UI", Font.BOLD, 14)
        lblPhrase.foreground = Color(0, 102, 102)

        panelInfo.add(lblStats)
        panelInfo.add(lblResult)
        panelInfo.add(lblPhrase)
        add(panelInfo, BorderLayout.CENTER)

        val btnOpenInput = JButton("Ввести данные")
        val panelButton = JPanel().apply {
            border = BorderFactory.createEmptyBorder(0, 0, 20, 0)
            add(btnOpenInput)
        }
        add(panelButton, BorderLayout.SOUTH)

        btnOpenInput.addActionListener { controller.openInputDialog(this) }
    }

    override fun onModelChanged() {
        lblStats.text = "План: ${model.plannedTasks} дел | Факт: ${model.completedTasks} дел"
        lblResult.text = String.format("Коэффициент лени: %.2f", model.lazinessRatio)
        lblPhrase.text = "Итог: ${model.feedbackPhrase}"
    }
}